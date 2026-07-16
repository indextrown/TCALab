//
//  CounterReducer.swift
//  TCADemo
//
//  Created by 김동현 on 6/9/26.
//

import ComposableArchitecture

@Reducer
struct CounterReducer {
    @ObservableState
    struct State {
        var count: Int = 0
        var numberFact: String?
    }
    
    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case numberFactButtonTapped
        case numberFactResponse(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                return .none
            case .decrementButtonTapped:
                state.count -= 1
                return .none
            case .numberFactButtonTapped:
                /*
                 이거랑 같은 의미 즉 state.count값을 복사해서 count라는 상수로 저장해두는것
                let count = state.count
                .run { send in
                    print(count)
                }
                 */
                return .run { [count = state.count] send in
                    let fact = await fetchNumberFact(count)
                    await send(.numberFactResponse(fact))
                }
                
            case .numberFactResponse(let fact):
                state.numberFact = fact
                return .none
            }
        }
    }
    
    private func fetchNumberFact(_ count: Int) async -> String {
        try? await Task.sleep(for: .seconds(1))
        return "\(count)에 대한 샘플 비동기 결과입니다."
    }
}
