//
//  FactFeature.swift
//  TCALab
//
//  Created by 김동현 on 6/26/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FactFeature {
    @ObservableState
    struct State: Equatable {
        var number = 0
        var fact = ""
        var isLoading = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case factButtonTapped
        case factResponse(Result<String, Error>)
    }
    
    @Dependency(\.factClient) var factClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .factButtonTapped:
                state.isLoading = true
                state.fact = ""
                let number = state.number
                return .run { send in
                    do {
                        let fact = try await factClient.fetch(number)
                        await send(.factResponse(.success(fact)))
                    } catch {
                        await send(.factResponse(.failure(error)))
                    }
                }
                
            case .factResponse(.success(let fact)):
                state.isLoading = false
                state.fact = fact
                return .none
                
            case .factResponse(.failure):
                state.isLoading = false
                state.fact = "불러오기에 실패했습니다."
                return .none
            }
        }
    }
}
