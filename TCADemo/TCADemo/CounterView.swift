//
//  CounterView.swift
//  TCADemo
//
//  Created by 김동현 on 6/9/26.
//

import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: StoreOf<CounterReducer>
    var body: some View {
        VStack {
            Form {
                Section {
                    Text("\(store.count)")
                    Button("Decrement") { store.send(.decrementButtonTapped) }
                    Button("Increment") { store.send(.incrementButtonTapped) }
                }
                
                Section {
                    Button("Number fact") { store.send(.numberFactButtonTapped) }
                }
                
                if let fact = store.numberFact {
                    Text(fact)
                }
            }
        }
    }
}

extension StoreOf<CounterReducer> {
    static let preview = Store(
        initialState: .init(),
        reducer: { CounterReducer() }
    )
}

#Preview {
    CounterView(store: .preview)
}
