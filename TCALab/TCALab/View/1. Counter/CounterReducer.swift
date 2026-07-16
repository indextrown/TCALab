//
//  CounterReducer.swift
//  TCALab
//
//  Created by 김동현 on 6/13/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CounterReducer {
    @Dependency(\.numberFact) var numberFact
    
    @ObservableState
    struct State: Equatable {
        var count = 0
        var numberFact: String?
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case numberFactButtonTapped
        case numberFactResponse(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                return .none
                
            case .numberFactButtonTapped:
                return .run { [count = state.count] send in
                    /*
                     [기존방식]
                    let (data, _) = try await URLSession.shared.data(
                        from: URL(string: "http://number-trivia.com/\(count)/trivia")!
                    )
                    await send(.numberFactResponse(String(decoding: data, as: UTF8.self)))
                     */
                    
                    let fact = try await numberFact.fetch(count)
                    await send(.numberFactResponse(fact))
                }
                
            case .numberFactResponse(let fact):
                state.numberFact = fact
                return .none
            }
        }
    }
}
