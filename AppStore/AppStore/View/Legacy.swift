//
//  Legacy.swift
//  AppStore
//
//  Created by 김동현 on 6/10/26.
//

//import ComposableArchitecture
//
//@Reducer
//struct CounterFeature {
//  struct State: Equatable {
//    var count = 0
//  }
//
//  enum Action {
//    case incrementButtonTapped
//  }
//
//  var body: some ReducerOf<Self> {
//    Reduce { state, action in
//      switch action {
//      case .incrementButtonTapped:
//        state.count += 1
//        return .none
//      }
//    }
//  }
//}
//
//@Reducer
//struct LegacyPath {
//  enum State: Equatable {
//    case counter(CounterFeature.State)
//  }
//
//  enum Action {
//    case counter(CounterFeature.Action)
//  }
//
//  var body: some ReducerOf<Self> {
//    Scope(state: \.counter, action: \.counter) {
//      CounterFeature()
//    }
//  }
//}
//
//
//import ComposableArchitecture
//
//@Reducer
//struct Feature {
//  @ObservableState
//  struct State: Equatable {
//    var path = StackState<Path.State>()
//  }
//
//  enum Action {
//    case path(StackActionOf<Path>)
//  }
//
//  @Reducer
//  enum Path {
//    case counter(CounterFeature)
//  }
//
//  var body: some ReducerOf<Self> {
//    Reduce { state, action in
//      return .none
//    }
//    .forEach(\.path, action: \.path) {
//      Path()
//    }
//  }
//}

//import ComposableArchitecture
//
//@Reducer
//struct CounterFeature {
//  struct State: Equatable {
//    var count = 0
//  }
//
//  enum Action {
//    case incrementButtonTapped
//  }
//
//  var body: some ReducerOf<Self> {
//    Reduce { state, action in
//      switch action {
//      case .incrementButtonTapped:
//        state.count += 1
//        return .none
//      }
//    }
//  }
//}
//
//@Reducer
//struct Feature {
//  struct State: Equatable {
//    var path = StackState<Path.State>()
//  }
//
//  enum Action {
//    case path(StackActionOf<Path>)
//  }
//
//  @Reducer
//  struct Path {
//    enum State: Equatable {
//      case counter(CounterFeature.State)
//    }
//
//    enum Action {
//      case counter(CounterFeature.Action)
//    }
//
//    var body: some ReducerOf<Self> {
//      Scope(state: \.counter, action: \.counter) {
//        CounterFeature()
//      }
//    }
//  }
//
//  var body: some ReducerOf<Self> {
//    Reduce { state, action in
//      return .none
//    }
//    .forEach(\.path, action: \.path) {
//      Path()
//    }
//  }
//}


import ComposableArchitecture

@Reducer
struct CounterFeature {
  struct State: Equatable {
    var count = 0
  }

  enum Action {
    case incrementButtonTapped
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .incrementButtonTapped:
        state.count += 1
        return .none
      }
    }
  }
}

@Reducer
struct Feature {
  struct State {
    var path = StackState<Path.State>()
  }

  enum Action {
    case path(StackActionOf<Path>)
  }

  @Reducer
  enum Path {
    case counter(CounterFeature)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      return .none
    }
    .forEach(\.path, action: \.path)
  }
}
