//
//  EditImageReducer.swift
//  AppStore
//
//  Created by 김동현 on 3/27/26.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditImageReducer {
    struct State {
        
    }
    
    enum Action {
        
    }
}

struct EditImageView: View {
    @Bindable var store: StoreOf<EditImageReducer>
    
    var body: some View {
        Text("EditImageView")
    }
}
