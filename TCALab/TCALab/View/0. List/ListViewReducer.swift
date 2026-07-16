//
//  ListViewReducer.swift
//  TCALab
//
//  Created by 김동현 on 6/13/26.
//

import ComposableArchitecture

@Reducer
struct ListViewReducer {
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case counterRowTapped
        case treeNavigationTapped
        case treeNavigationV2Tapped
        case dependencyTapped
        case scopeTapped
        case basicTreeNavigationTapped
        case basicEnumTreeNavigationTapped
    }
    
    @Reducer
    enum Path {
        case counter(CounterReducer)
        case treeNavigation(TreeNavigationFeature)
        case treeNavigationV2(TreeNavigationFeatureV2)
        case dependency(FactFeature)
        case scope(ParentFeature)
        case basicTree(BasicTreeNavigationFeature)
        case basicEnumTree(BasicEnumTreeNavigationFeature)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case .counterRowTapped:
                state.path.append(.counter(CounterReducer.State()))
                return .none
            
            case .treeNavigationTapped:
                state.path.append(.treeNavigation(TreeNavigationFeature.State()))
                return .none
                
            case .treeNavigationV2Tapped:
                state.path.append(.treeNavigationV2(TreeNavigationFeatureV2.State()))
                return .none
                
            case .dependencyTapped:
                state.path.append(.dependency(FactFeature.State()))
                return .none
                
            case .scopeTapped:
                state.path.append(.scope(ParentFeature.State()))
                return .none
                
            case .basicTreeNavigationTapped:
                state.path.append(.basicTree(BasicTreeNavigationFeature.State()))
                return .none
                
            case .basicEnumTreeNavigationTapped:
                state.path.append(.basicEnumTree(BasicEnumTreeNavigationFeature.State()))
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
