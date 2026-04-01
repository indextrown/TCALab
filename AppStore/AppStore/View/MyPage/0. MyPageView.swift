//
//  MyPageView.swift
//  AppStore
//
//  Created by 김동현 on 3/26/26.
//

import SwiftUI
import Alamofire
import ComposableArchitecture
import SwiftData

// 이름 변경, 이메일 변경, 이미지 변경
enum MyPageOption: CaseIterable {
    case name
    case email
    case image
    
    var title: String {
        switch self {
        case .name:  "이름"
        case .email: "이메일"
        case .image: "프로필 이미지"
        }
    }
}

struct MyPageView: View {
    
    @Bindable var store: StoreOf<MyPageReducer>
    
    @Query var user: [User]
    var firstUser: User? {
        user.first
    }
    
    var body: some View {
        
        NavigationStackStore(
            store.scope(state: \.path, action: \.path)) {
                ZStack {
                    Color.black.ignoresSafeArea()
                    VStack {
                        ForEach(MyPageOption.allCases, id: \.self) { option in
                            let subTitle = switch option {
                            case .name: store.userName
                            case .email: store.userEmail
                            case .image: ""
                            }
                            listItem(
                                option: option,
                                subtitle: subTitle
                            )
                        }
                    }
                }
                .onAppear {
                    guard let firstUser else { return }
                    store.send(.onAppear(firstUser))
                }
            } destination: { store in
                switch store.state {
                case .name:
                    // store는 현재 전체 store
                    // 지금 상태가 name이면 name전용 store를 만들어서 화면에 넘겨라
                    if let store = store.scope(state: \.name, action: \.name) {
                        EditNameView(store: store)
                    }
                case .email:
                    if let store = store.scope(state: \.email, action: \.email) {
                        EditEmailView(store: store)
                    }
                case .image:
                    if let store = store.scope(state: \.image, action: \.image) {
                        EditImageView(store: store)
                    }
                }
            }
    }
    
    func listItem(option: MyPageOption, subtitle: String) -> some View {
        Button {
            store.send(.tapOption(option))
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .bold))
                    
                    Text(subtitle)
                        .foregroundStyle(Color(UIColor.lightGray))
                        .font(.system(size: 16))
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(UIColor.darkGray))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

//#Preview {
//    MyPageView()
//}
