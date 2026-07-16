//
//  TCALabApp.swift
//  TCALab
//
//  Created by 김동현 on 6/13/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCALabApp: App {
    var body: some Scene {
        WindowGroup {
//            CounterView(store: Store(
//                initialState: CounterReducer.State(), reducer: {
//                CounterReducer()
//            }))
            ListView(store: Store(
                initialState: ListViewReducer.State(),
                reducer: {
                    ListViewReducer()
                })
            )
        }
    }
}
