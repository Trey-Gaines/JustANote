//
//  Tags.swift
//  JustANote
//
//  Created by Trey Gaines on 6/2/24.
//

import SwiftData

@Model
class Tags {
    //@Attribute(.unique) - Apparently CloudKit doesn't handle unique variables. Not sure
    var title: String = ""
    var notes: [Note]?
    
    init(title: String) {
        self.title = title
    }
}
