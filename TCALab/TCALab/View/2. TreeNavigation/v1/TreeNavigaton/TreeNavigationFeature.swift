//
//  TreeNavigationFeature.swift
//  TCALab
//
//  Created by 김동현 on 6/13/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TreeNavigationFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var addItem: AddItemFeature.State?
        var items: IdentifiedArrayOf<Item> = []
    }
    
    enum Action {
        case addButtonTapped
        case addItem(PresentationAction<AddItemFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addItem = AddItemFeature.State()
                return .none
                
            case .addItem(.presented(.saveButtonTapped)):
                guard let addItem = state.addItem else {
                    return .none
                }
                
                let item = Item(
                    id: UUID(),
                    name: addItem.name
                )
                
                state.items.append(item)
                state.addItem = nil
                return .none
            case .addItem:
                return .none
            }
        }
        .ifLet(\.$addItem, action: \.addItem) {
            AddItemFeature()
        }
    }
}
