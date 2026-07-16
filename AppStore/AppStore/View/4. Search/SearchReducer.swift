//
//  SearchReducer.swift
//  AppStore
//
//  Created by 김동현 on 6/7/26.
//

import ComposableArchitecture

@Reducer
struct SearchReducer {
    @ObservableState
    struct State {
        var keyword: String = ""
    }
    
    enum Action {
        case inputText(String)
        case clearText
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .inputText(let text):
                state.keyword = text
            case .clearText:
                state.keyword = ""
            }
            return .none
        }
    }
}
