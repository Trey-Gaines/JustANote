//
//  Tags.swift
//  JustANote
//
//  Created by Trey Gaines on 6/2/24.
//

import SwiftData

@Model
final class Tags {
    @Attribute(.unique)
    var title: String
    var notes: [Note]?
    
    init(title: String) {
        self.title = title
    }
}
