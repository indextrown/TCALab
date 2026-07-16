//
//  EditImageReducer.swift
//  AppStore
//
//  Created by 김동현 on 3/27/26.
//

import ComposableArchitecture
import SwiftUI
import Photos

@Reducer
struct EditImageReducer {
    
    @ObservableState
    struct State {
        @Presents var alert: AlertState<Action>?
        var userImage: Image?
        var assets: [PHAsset] = []
        var selectedPhoto: (id: String, data: Data)?
    }
    
    enum Action {
        case onAppear(image: Data?)
        case setUserImageData(Data?)
        case setUserImage(Image)
        case authResult(Bool)
        case onSelectPhoto(id: String, data: Data)
        case onEditSuccess(Data)
        case onEditFail(String)
        case alert(PresentationAction<Action>)
    }
     
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear(let imageData):
                return Effect.run { send in
                    let isAuth = await PhotoManager.requestAuthorization()
                    // return .send(.authResult(isAuth))
                    await send(.authResult(isAuth)) // 권한의 결과값을 보낸다
                    await send(.setUserImageData(imageData))
                }
            case .authResult(let isAuth):
                if isAuth {
                    let assets = PhotoManager.getAssets()
                    state.assets = assets
                } else {
                    state.alert = AlertState.createAlert(type: .error(message: "권한이 없습니다"))
                }
            case .setUserImageData (let data):
                guard let data, let uiImage = UIImage(data: data) else { return .none }
                return .send(.setUserImage(Image(uiImage: uiImage)))
                
            case .setUserImage(let image):
                state.userImage = image
                
            case .onSelectPhoto(let id, let data):
                state.selectedPhoto = (id: id, data: data)
            case .onEditSuccess(let data):
                return .send(.setUserImageData(data))
            case .onEditFail(let error):
                state.alert = AlertState.createAlert(type: .error(message: error))
            case .alert:
                return .none
            }
            return .none
        }
    }
}
