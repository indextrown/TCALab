//
//  EditNameReducer.swift
//  AppStore
//
//  Created by 김동현 on 3/27/26.
//

import ComposableArchitecture
import SwiftUI
import SwiftData

@Reducer
struct EditNameReducer {
    @ObservableState
    struct State {
        var name: String
        
        // 트리 기반 네비게이션을 활용 & alert 생성
        // Presents state
        @Presents var alert: AlertState<Action.AlertAction>? // nil이면 사라짐 / nil이면 뜸
    }
     
    enum Action {
        case inputName(String)
        case clearText
        case onEditSuccess(String)
        case onEditFail(String)
        
        // alert
        case showALert(String)
        case alert(PresentationAction<AlertAction>)
        
        // Presents action
        enum AlertAction {
            
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .inputName(let name):
                state.name = name
                return .none
            case .clearText:
                state.name = ""
                return .none
            case .onEditSuccess:
                return .none
            case .onEditFail(let message):
                // TODO: - Alert
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
        .ifLet(\.$alert, action: \.alert)
    }
}

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
