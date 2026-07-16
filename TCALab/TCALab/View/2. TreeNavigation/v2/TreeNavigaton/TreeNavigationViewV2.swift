//
//  TreeNavigationView.swift
//  TCALab
//
//  Created by 김동현 on 6/13/26.
//

import SwiftUI
import ComposableArchitecture

struct TreeNavigationViewV2: View {
    @Bindable var store: StoreOf<TreeNavigationFeatureV2>
    
    var body: some View {
        List {
            ForEach(store.items) { item in
                Text(item.name)
            }
        }
        .navigationTitle("Items")
        .toolbar {
            Button("Add") {
                store.send(.addButtonTapped)
            }
        }
        .sheet(
            item: $store.scope(
                state: \.destination,
                action: \.destination
            ).addItem
        ) { store in
            AddItemView(store: store)
        }
    }
}
