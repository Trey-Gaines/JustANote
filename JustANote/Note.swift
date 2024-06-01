//
//  Note.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import Foundation
import SwiftData

@Model
final class Note {
    var timestamp: Date
    var title: String
    var userNote: String
    var latitude: Double? // Store latitude
    var longitude: Double? // Store longitude
    var userImages: [Data]? //Store images the user might add
    
    
    init(timestamp: Date, title: String, userNote: String) {
        self.timestamp = timestamp
        self.title = title
        self.userNote = userNote
    }
}
