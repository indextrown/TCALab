//
//  AppStoreApp.swift
//  AppStore
//
//  Created by 김동현 on 3/26/26.
//

/*
 SwiftData 기본 사용법
 https://dev-in-gym.tistory.com/entry/SwiftData-기본-사용법-Model-ModelContext-Query
 
 일반적인 내부 데이터(SQLite DB)
 ~/Library/Application Support/[앱번들ID].store/
 
 @Attribute(.externalStorage)를 사용한 데이터
 ~/Library/Application Support/[앱 번들 ID].store/external_storage/
 */
import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct AppStoreApp: App {
    var body: some Scene {
        WindowGroup {
            MyPageView(store: Store(
                initialState: MyPageReducer.State(),
                reducer: { MyPageReducer() }))
        }
        .modelContainer(modelContainer)
    }
}

private var modelContainer: ModelContainer = {
    let schema = Schema([User.self])
    let modelConfiguration = ModelConfiguration(schema: schema)
    
    do {
        let container = try ModelContainer(
            for: schema,
            configurations: modelConfiguration
        )
        Task { @MainActor in
            setInitialData(context: container.mainContext)
        }
        return container
    } catch {
        fatalError("ModelContainer 생성 실패")
    }
}()

// 초기값이 없으면 넣어주는 함수
private func setInitialData(context: ModelContext) {
    let descriptor = FetchDescriptor<User>()
    if let _ = try? context.fetch(descriptor).isEmpty {
        let user = User(name: "Index", email: "Index@gmail.com")
        context.insert(user)
        try? context.save()
    }
}
