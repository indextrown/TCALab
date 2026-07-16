//
//  TwoCounterView.swift
//  TCALab
//
//  Created by 김동현 on 6/27/26.
//

import SwiftUI
import ComposableArchitecture

struct ParentView: View {
    let store: StoreOf<ParentFeature>

    var body: some View {
        Form {
            ChildView(
                title: "Counter1",
                store: store.scope(
                    state: \.child,
                    action: \.child
                )
            )

            HStack {
                Text("Counter2")

                Spacer()

                Button("-") {
                    store.send(.parentDecrementButtonTapped)
                }
                .buttonStyle(.borderless)

                Text("\(store.parentCount)")
                    .frame(width: 32)

                Button("+") {
                    store.send(.parentIncrementButtonTapped)
                }
                .buttonStyle(.borderless)
            }

            HStack {
                Text("Reset Counter")

                Spacer()

                Button("OK") {
                    store.send(.resetCounter)
                }
                .buttonStyle(.borderless)
            }
        }
    }
}
