//
//  TwoCounter.swift
//  TCALab
//
//  Created by 김동현 on 6/27/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        var child = ChildFeature.State()
        var parentCount = 0
    }
    
    enum Action {
        case child(ChildFeature.Action)
        case parentDecrementButtonTapped
        case parentIncrementButtonTapped
        case resetCounter
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.child, action: \.child) {
            ChildFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .child:
                return .none
                
            case .parentDecrementButtonTapped:
                state.parentCount -= 1
                return .none
                
            case .parentIncrementButtonTapped:
                state.parentCount += 1
                return .none
                
            case .resetCounter:
                state.child.count = 0
                state.parentCount = 0
                return .none
            }
        }
    }
}
