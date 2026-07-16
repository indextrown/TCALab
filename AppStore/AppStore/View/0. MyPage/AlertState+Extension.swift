//
//  AlertState+Extension.swift
//  AppStore
//
//  Created by 김동현 on 4/1/26.
//

import ComposableArchitecture

enum AlertType {
    case error(message: String)
}

extension AlertState {
    static func createAlert(type: AlertType) -> AlertState {
        switch type {
        case .error(let message):
            return AlertState.init(
                title: {
                    TextState("에러")
                }, actions: {
                    ButtonState {
                        TextState("확인")
                    }
                }, message: {
                    TextState("에러가 발생했습니다: \(message)")
                })
        }
    }
}
