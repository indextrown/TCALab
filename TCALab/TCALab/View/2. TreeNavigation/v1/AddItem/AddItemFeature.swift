//
//  AddItemFeature.swift
//  TCALab
//
//  Created by 김동현 on 6/13/26.
//

import Foundation
import ComposableArchitecture

struct Item: Equatable, Identifiable {
    let id: UUID
    var name: String
}

@Reducer
struct AddItemFeature {
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        var name = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case saveButtonTapped
        case cancelButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .saveButtonTapped:
                return .run { _ in
                    await dismiss()
                }
            case .cancelButtonTapped:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
}
