//
//  EditNameReducer.swift
//  AppStore
//
//  Created by 김동현 on 3/27/26.
//

import ComposableArchitecture
import SwiftUI
import SwiftData

@Reducer
struct EditNameReducer {
    @ObservableState
    struct State {
        var name: String
        
        // 트리 기반 네비게이션을 활용 & alert 생성
        // Presents state
        @Presents var alert: AlertState<Action.AlertAction>? // nil이면 사라짐 / nil이면 뜸
    }
     
    enum Action {
        case inputName(String)
        case clearText
        case onEditSuccess(String)
        case onEditFail(String)
        
        // alert
        case showALert(String)
        case alert(PresentationAction<AlertAction>)
        
        // Presents action
        enum AlertAction {
            
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .inputName(let name):
                state.name = name
                return .none
            case .clearText:
                state.name = ""
                return .none
            case .onEditSuccess:
                return .none
            case .onEditFail(let message):
                // TODO: - Alert
                return .send(.showALert(message))
            case .showALert(let message):
                state.alert = AlertState.init(title: {
                    TextState("에러")
                }, actions: {
                    ButtonState {
                        TextState("확인")
                    }
                }, message: {
                    TextState("에러가 발생했습니다: \(message)")
                })
                return .none
            case .alert(let presentationAction):
                switch presentationAction {
                case .presented(let action):
                    return .none
                    
                case .dismiss:
                    state.alert = nil
                    return .none
                }
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
