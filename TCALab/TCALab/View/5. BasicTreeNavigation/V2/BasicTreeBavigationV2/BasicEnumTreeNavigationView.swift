//
//  BasicTreeNavigation.swift
//  TCALab
//
//  Created by 김동현 on 7/15/26.
//

import SwiftUI
import ComposableArchitecture

struct BasicEnumTreeNavigationView: View {
    @Bindable var store: StoreOf<BasicEnumTreeNavigationFeature>
    
    var body: some View {
//        NavigationStack { 이미 중첩 상태이므로 주석
            List {
                ForEach(store.items) { item in
                    Text(item.title)
                }
                .onDelete { indexSet in
                    store.send(.deleteItem(indexSet))
                }
            }
            .navigationTitle("Items")
            .toolbar {
                Button {
                    store.send(.addButtonTapped)
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
            .sheet(
                item: $store.scope(\.destination, action: \.destination).addItem
            ) { addItemStore in
                BasicAddItemView(store: addItemStore)
            }
    }
        
//    }
}
