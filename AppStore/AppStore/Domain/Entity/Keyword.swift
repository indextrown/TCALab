//
//  Keyword.swift
//  AppStore
//
//  Created by 김동현 on 6/7/26.
//

import Foundation
import SwiftData

@Model
final class Keyword: Identifiable {
    var title: String
    var date: Date
    
    init(title: String, date: Date) {
        self.title = title
        self.date = date
    }
}
