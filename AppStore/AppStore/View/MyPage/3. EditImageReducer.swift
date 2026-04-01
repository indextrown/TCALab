//
//  EditImageReducer.swift
//  AppStore
//
//  Created by 김동현 on 3/27/26.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditImageReducer {
    
    @ObservableState
    struct State {
        @Presents var alert: AlertState<Action>?
    }
    
    enum Action {
        case onAppear
        case authResult(Bool)
    }
     
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return Effect.run { send in
                    let isAuth = await PhotoManager.requestAuthorization()
                    // return .send(.authResult(isAuth))
                    await send(.authResult(isAuth)) // 권한의 결과값을 보낸다
                }
            case .authResult(let isAuth):
                if isAuth {
                    let assets = PhotoManager.getAssets()
                } else {
                    state.alert = AlertState.createAlert(type: .error(message: "권한이 없습니다"))
                }
                
                return .none
            }
            return .none
        }
    }
}

struct EditImageView: View {
    @Bindable var store: StoreOf<EditImageReducer>
    
    var body: some View {
        Text("EditImageView")
            .onAppear {
                store.send(.onAppear)
            }
    }
}
