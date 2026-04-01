//
//  EditEmailReducer.swift
//  AppStore
//
//  Created by 김동현 on 3/27/26.
//

import ComposableArchitecture
import SwiftUI
import SwiftData

@Reducer
struct EditEmailReducer {
    @ObservableState
    struct State {
        var email: String
        @Presents var alert: AlertState<Action>?
    }
    
    enum Action {
        case inputEmail(String)
        case clearText
        case onEditSuccess(String)
        case onEditFail(String)
        
        // alert
        case showALert(String)
        case alert(PresentationAction<Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .inputEmail(let email):
                state.email = email
                return .none
            case .clearText:
                state.email = ""
                return .none
            case .onEditSuccess(let email):
                return .none
            case .onEditFail(let message):
                return .send(.showALert(message))
            case .showALert(let message):
                state.alert = AlertState.init(title: {
                    TextState("에러")
                }, actions: {
                    ButtonState {
                        TextState("확인")
                    }
                }, message: {
                    TextState("에러가 발생했습니다: \(message)")
                })
                return .none
            case .alert(let presentationAction):
                switch presentationAction {
                case .presented(let action):
                    return .none
                    
                case .dismiss:
                    state.alert = nil
                    return .none
                }
            }
        }
        .ifLet(\.alert, action: \.alert)
    }
}

struct EditEmailView: View {
    @Bindable var store: StoreOf<EditEmailReducer>
    @Query var users: [User]
    @Environment(\.modelContext) private var context
    private var user: User? {
        users.first
    }
    
    var body: some View {
        VStack {
            Text("이메일을 입력해 주세요")
            TextField(
                "이메일을 입력해 주세요",
                text: $store.email.sending(\.inputEmail)
            )
            .padding(.trailing, 32)
            .overlay(alignment: .topTrailing) {
                if !store.email.isEmpty {
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
        }
        .padding(20)
        .alert($store.scope(state: \.alert, action: \.alert))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editEmail(email: store.email)
                } label: {
                    Text("저장")
                }
            }
        }
    }
    
    func editEmail(email: String) {
        guard !email.isEmpty else {
            store.send(.onEditFail("이메일을 입력해 주세요"))
            return
        }
        
        user?.email = email
        
        do {
            try context.save()
            store.send(.onEditSuccess(email))
        } catch {
            store.send(.onEditFail("에러가 발생했습니다: \(error)"))
        }
    }
}
