//
//  TCADemoApp.swift
//  TCADemo
//
//  Created by 김동현 on 6/9/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCADemoApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: Store(
                    initialState: CounterReducer.State(),
                    reducer: { CounterReducer() })
            )
        }
    }
}
