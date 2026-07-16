//
//  BasicTreeNavigationFeature.swift
//  TCALab
//
//  Created by 김동현 on 7/15/26.
//
// https://github.com/pointfreeco/swift-identified-collections/blob/main/Sources/IdentifiedCollections/IdentifiedArray/IdentifiedArray.swift

import ComposableArchitecture
import Foundation

@Reducer
struct BasicTreeNavigationFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var addItem: BasicAddItemFeature.State?
        
        /**
         일반 Array
         특정 ID의 값을 수정하려면 먼저 위치를 찾아야 한다
         if let index = items.firstIndex(where: { $0.id == itemID }) {
             items[index].name = "수정됨"
         }
         
         IdentifiedArrayOf
         ID로 바로 접근할 수 있다.
         items[id: itemID]?.name = "수정됨"

         */
        var items: IdentifiedArrayOf<BasicItem> = []
    }
    
    enum Action {
        case addButtonTapped
        case deleteItem(IndexSet)
        case addItem(PresentationAction<BasicAddItemFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addItem = BasicAddItemFeature.State()
                return .none
                
            case .deleteItem(let indexSet):
                for index in indexSet.sorted(by: >) {
                    state.items.remove(at: index)
                }
                return .none
                
            case .addItem(.presented(.delegate(.save(let item)))):
                state.items.append(item)
                state.addItem = nil
                return .none
                
            case .addItem(.presented(.delegate(.cancelled))):
                state.addItem = nil
                return .none
                
            case .addItem:
                return .none
            }
        }
        .ifLet(\.$addItem, action: \.addItem) {
            BasicAddItemFeature()
        }
    }
}

