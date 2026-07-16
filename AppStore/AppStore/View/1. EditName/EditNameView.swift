//
//  EditNameView.swift
//  AppStore
//
//  Created by 김동현 on 6/7/26.
//

import ComposableArchitecture
import SwiftUI
import SwiftData

struct EditNameView: View {
    @Bindable var store: StoreOf<EditNameReducer>
    @Query var users: [User]
    @Environment(\.modelContext) private var context
    private var user: User? {
        users.first
    }
     
    var body: some View {
        VStack {
            Text("이름을 입력해 주세요")
            TextField(
                "이름을 입력해 주세요",
                text: $store.name.sending(\.inputName)
            )
            .padding(.trailing, 32)
            .overlay(alignment: .topTrailing) {
                if !store.name.isEmpty {
                    Button {
                        store.send(.clearText)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color(.systemGray))
                    }
                }
            }
            .submitLabel(.done)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(height: 40)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .onSubmit {
                editName(name: store.name)
            }
        }
        .padding(20)
        .alert($store.scope(state: \.alert, action: \.alert))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editName(name: store.name)
                } label: {
                    Text("저장")
                }
            }
        }
    }
    
    func editName(name: String) {
        guard !name.isEmpty else {
            store.send(.onEditFail("이름을 입력해주세요"))
            return
        }
        
        user?.name = name
        do {
            try context.save()
            store.send(.onEditSuccess(name))
        } catch {
            store.send(.onEditFail(error.localizedDescription))
        }
        
    }
}
