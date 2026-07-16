//
//  FactView.swift
//  TCALab
//
//  Created by 김동현 on 6/26/26.
//

import SwiftUI
import ComposableArchitecture

struct FactView: View {
    @Bindable var store: StoreOf<FactFeature>

    var body: some View {
        VStack(spacing: 20) {
            Text("Number Fact")
                .font(.title)

            Stepper(
                "숫자: \(store.number)",
                value: $store.number,
                in: 0...100
            )

            Button {
                store.send(.factButtonTapped)
            } label: {
                if store.isLoading {
                    ProgressView()
                } else {
                    Text("Fact 가져오기")
                }
            }
            .disabled(store.isLoading)

            Text(store.fact)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

#Preview {
    FactView(
        store: Store(
            initialState: FactFeature.State()
        ) {
            FactFeature()
        }
    )
}
