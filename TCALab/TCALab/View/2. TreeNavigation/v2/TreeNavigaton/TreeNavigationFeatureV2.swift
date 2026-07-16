//
//  TreeNavigationFeature.swift
//  TCALab
//
//  Created by 김동현 on 6/13/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TreeNavigationFeatureV2 {
    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
        var items: IdentifiedArrayOf<Item> = []
    }
    
    enum Action {
        case addButtonTapped
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Reducer
    enum Destination {
        case addItem(AddItemFeature)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addItem(AddItemFeature.State())
                return .none

            case .destination(.presented(.addItem(.saveButtonTapped))):
                guard case let .addItem(addItem) = state.destination else {
                    return .none
                }

                let item = Item(
                    id: UUID(),
                    name: addItem.name
                )

                state.items.append(item)
                state.destination = nil
                return .none

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
