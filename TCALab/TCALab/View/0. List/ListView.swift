//
//  ListView.swift
//  TCALab
//
//  Created by 김동현 on 6/13/26.
//

import SwiftUI
import ComposableArchitecture

struct ListView: View {
    @Bindable var store: StoreOf<ListViewReducer>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            List {
                Button("counter") {
                    store.send(.counterRowTapped)
                }
                
                Button("tree-navigation") {
                    store.send(.treeNavigationTapped)
                }
                
                Button("tree-navigation V2") {
                    store.send(.treeNavigationV2Tapped)
                }
                
                Button("dependency") {
                    store.send(.dependencyTapped)
                }
                
                Button("scope") {
                    store.send(.scopeTapped)
                }
                
                Button("basic-tree") {
                    store.send(.basicTreeNavigationTapped)
                }
                
                Button("basic-enum-tree") {
                    store.send(.basicEnumTreeNavigationTapped)
                }
            }
        } destination: { store in
            switch store.case {
            case .counter(let store):
                CounterView(store: store)
            case .treeNavigation(let store):
                TreeNavigationView(store: store)
            case .treeNavigationV2(let store):
                TreeNavigationViewV2(store: store)
            case .dependency(let store):
                FactView(store: store)
            case .scope(let store):
                ParentView(store: store)
            case .basicTree(let store):
                BasicTreeNavigationView(store: store)
            case .basicEnumTree(let store):
                BasicEnumTreeNavigationView(store: store)
            }
        }
    }
}
