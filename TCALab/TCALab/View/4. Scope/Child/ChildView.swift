//
//  ChildView.swift
//  TCALab
//
//  Created by 김동현 on 6/27/26.
//

//
//  CounterView.swift
//

import SwiftUI
import ComposableArchitecture

struct ChildView: View {
    let title: String
    let store: StoreOf<ChildFeature>

    var body: some View {
        HStack {
            Text(title)

            Spacer()

            Button("-") {
                store.send(.decrementButtonTapped)
            }
            .buttonStyle(.borderless)

            Text("\(store.count)")
                .frame(width: 32)

            Button("+") {
                store.send(.incrementButtonTapped)
            }
            .buttonStyle(.borderless)
        }
    }
}
