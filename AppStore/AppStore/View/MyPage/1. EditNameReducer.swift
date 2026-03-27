//
//  EditNameReducer.swift
//  AppStore
//
//  Created by 김동현 on 3/27/26.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditNameReducer {
    struct State {
        var name: String
    }
    
    enum Action {
        
    }
}

struct EditNameView: View {
    @Bindable var store: StoreOf<EditNameReducer>
     
    var body: some View {
        Text("EditNameView")
    }
}
