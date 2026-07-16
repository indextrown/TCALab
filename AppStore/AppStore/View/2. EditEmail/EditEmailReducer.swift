//
//  EditEmailReducer.swift
//  AppStore
//
//  Created by 김동현 on 3/27/26.
//

import ComposableArchitecture
import SwiftUI
import SwiftData

@Reducer
struct EditEmailReducer {
    @ObservableState
    struct State {
        var email: String
        @Presents var alert: AlertState<Action>?
    }
    
    enum Action {
        case inputEmail(String)
        case clearText
        case onEditSuccess(String)
        case onEditFail(String)
        
        // alert
        case showALert(String)
        case alert(PresentationAction<Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .inputEmail(let email):
                state.email = email
                return .none
            case .clearText:
                state.email = ""
                return .none
            case .onEditSuccess(let email):
                return .none
            case .onEditFail(let message):
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
        .ifLet(\.alert, action: \.alert)
    }
}

