//
//  TCALabTests.swift
//  TCALabTests
//
//  Created by 김동현 on 6/13/26.
//

import Testing
import ComposableArchitecture
@testable import TCALab

@MainActor
struct CounterReducerTests {
    @Test
    func basics() async {
        let store = TestStore(initialState: CounterReducer.State()) {
            CounterReducer()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0) is a good number" }
        }

        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }

        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }

        await store.send(.numberFactButtonTapped)

        await store.receive(\.numberFactResponse) {
            $0.numberFact = "0 is a good number"
        }
    }
}
