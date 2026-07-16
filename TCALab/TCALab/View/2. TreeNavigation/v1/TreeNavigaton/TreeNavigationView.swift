//
//  TreeNavigationView.swift
//  TCALab
//
//  Created by 김동현 on 6/13/26.
//

import SwiftUI
import ComposableArchitecture

struct TreeNavigationView: View {
    @Bindable var store: StoreOf<TreeNavigationFeature>
    
    var body: some View {
//        NavigationStack {  이미 중첩 상태이므로 주석
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
            .sheet(item: $store.scope(state: \.addItem, action: \.addItem)) { store in
                AddItemView(store: store)
            }
//        }
    }
}
