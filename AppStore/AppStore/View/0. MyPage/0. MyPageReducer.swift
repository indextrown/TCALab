//
//  MyPageReducer.swift
//  AppStore
//
//  Created by 김동현 on 3/27/26.
//

import ComposableArchitecture

@Reducer
struct MypageStackReducer {
    @ObservableState
    enum State {
        case name(EditNameReducer.State)   // 이름 변경 페이지 리듀서 상태값
        case email(EditEmailReducer.State) // 이메일 변경 페이지 리듀서 상태값
        case image(EditImageReducer.State) // 이미지 변경 페이지 리듀서 상태값
    }
    
    enum Action {
        case name(EditNameReducer.Action)   // 이름 변경 페이지 리듀서 액션
        case email(EditEmailReducer.Action) // 이메일 변경 페이지 리듀서 액션
        case image(EditImageReducer.Action) // 이미지 변경 페이지 리듀서 액션
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.name, action: \.name) {
            EditNameReducer()
        }
        
        Scope(state: \.email, action: \.email) {
            EditEmailReducer()
        }
        
        Scope(state: \.image, action: \.image) {
            EditImageReducer()
        }
    }
}

@Reducer
struct MyPageReducer {
    @ObservableState
    struct State {
        var path: StackState<MypageStackReducer.State> = .init()
        var userName: String = ""
        var userEmail: String = ""
    }
    
    enum Action {
        case onAppear(User)
        case path(StackActionOf<MypageStackReducer>)
        case tapOption(MyPageOption)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .onAppear(let user):
                state.userName = user.name
                state.userEmail = user.email
                return Effect.none
                
            /*
             scope장점
             - 자식reducer 액션 쉽게 감지할 수 있다
             - 즉 MypageStackReducer의 Action들의 감지를 한번에 할 수 있다
             - 각 페이지 내부에서 처리할 액션은 처리하고 부모뷰에서(지금뷰) 처리할 액션은 따로 처리한다
             */
            case .path(let stackAction):
                switch stackAction {
                case .element(let id, let action):
                    switch action {
                    case .name(.onEditSuccess(let name)):
                        state.userName = name
                        state.path.pop(from: id)
                    case .email(.onEditSuccess(let email)):
                        state.userEmail = email
                        state.path.pop(from: id)
                    default: return .none
                    }
                    default: return .none
                }
                return Effect.none
                
            case .tapOption(let option):
                switch option {
                case .name:
                    state.path.append(.name(.init(name: state.userName)))
                case .email:
                    state.path.append(.email(.init(email: state.userEmail)))
                case .image:
                    state.path.append(.image(.init()))
                }
                return Effect.none
            }
        }
        .forEach(\.path, action: \.path) {
             MypageStackReducer()
        }
    }
}
