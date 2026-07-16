//
//  BasicAddItemFeature.swift
//  TCALab
//
//  Created by 김동현 on 7/16/26.
//

import ComposableArchitecture
import Foundation

struct BasicItem: Equatable, Identifiable {
    let id = UUID()
    var title: String
}

@Reducer
struct BasicAddItemFeature {
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        var title = ""
    }
    
    /**
     BindableAction: TextField, Toggle처럼 값을 양방향으로 변경하는 UI 사용시 nameChanged, isOnChanged 같은 액션을 하나씩 만들지 않도록 도와준다
     */
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case cancelButtonTapped
        case saveButtonTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case cancelled
            case save(BasicItem)
        }
    }
    
    var body: some ReducerOf<Self> {
        /**
         SwiftUI 입력값을 TCA의 State에 자동 반영하는 Reducer
         TextField, Toggle같은 양방향 바인딩용
         
         enum Action: BindableAction {
           case binding(BindingAction<State>)
         }

         var body: some ReducerOf<Self> {
           BindingReducer()
           Reduce { state, action in
             // ...
           }
         }
         */
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .cancelButtonTapped:
                return .send(.delegate(.cancelled))
            case .saveButtonTapped:
                let title = state.title.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !title.isEmpty else { return .none }
                return .send(.delegate(.save(BasicItem(title: title))))
            case .delegate:
                return .none
            }
        }
    }
}
