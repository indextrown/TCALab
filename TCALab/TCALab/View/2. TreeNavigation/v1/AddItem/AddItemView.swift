//
//  AddItemView.swift
//  TCALab
//
//  Created by 김동현 on 6/13/26.
//

import SwiftUI
import ComposableArchitecture

struct AddItemView: View {
    @Bindable var store: StoreOf<AddItemFeature>

    var body: some View {
        NavigationStack {
            Form {
                TextField("Item name", text: $store.name)
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        store.send(.cancelButtonTapped)
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.send(.saveButtonTapped)
                    }
                    .disabled(store.name.isEmpty)
                }
            }
        }
    }
}
