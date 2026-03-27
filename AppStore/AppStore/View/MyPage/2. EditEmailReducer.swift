//
//  EditEmailReducer.swift
//  AppStore
//
//  Created by 김동현 on 3/27/26.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditEmailReducer {
    struct State {
        var email: String
    }
    
    enum Action {
        
    }
}

struct EditEmailView: View {
    @Bindable var store: StoreOf<EditEmailReducer>
    
    var body: some View {
        Text("EditEmailView")
    }
}
