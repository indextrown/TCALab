//
//  BasicAddItemView.swift
//  TCALab
//
//  Created by 김동현 on 7/16/26.
//

import SwiftUI
import ComposableArchitecture

struct BasicAddItemView: View {
    @Bindable var store: StoreOf<BasicAddItemFeature>
    
    var body: some View {
        NavigationStack {
            Form {
                // 입력
                TextField("Title", text: $store.title)
            }
            .navigationTitle("Nex Item")
            .toolbar {
                ToolbarItem(
                    placement: .cancellationAction) {
                        // 취소
                        Button("Cancel") {
                            store.send(.cancelButtonTapped)
                        }
                    }
                
                ToolbarItem(
                    placement: .confirmationAction) {
                        Button("Save") {
                            store.send(.saveButtonTapped)
                        }
                        .disabled(
                            store.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        )
                    }
            }
        }
    }
}
