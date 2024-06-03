//
//  Note.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import Foundation
import SwiftData

@Model
final class Note: Identifiable {
    var id = UUID()
    var timestamp: Date
    var title: String
    var userNote: String
    var latitude: Double? // Store latitude
    var longitude: Double? // Store longitude
    var userImages: [Data]? //Store images the user might add
    var isFavorite: Bool
    var isInTrash: Bool
    
    
    //When I delete a note, the category won't be deleted with nullify
    //   Cascade will delete both the note and the category
    @Relationship(deleteRule: .nullify, inverse: \Tags.notes)
    var tagGiven: Tags?
    
    
    
    //Computed Properties
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: timestamp)
    }
    
    //Shorthands the userNote for preview
    var shortNote: String {
        if userNote.count > 20 {
            //set a string index, offset the startIndex by 20
            let index = userNote.index(userNote.startIndex, offsetBy: 20)
            //Create a substring from start to index, convert it to string
            //     and then trim the whitespaces and add "..."
            return String(userNote[..<index]).trimmingCharacters(in: .whitespacesAndNewlines) + "..."
        } else {
            return userNote
        }
    }
    
    //Gives a readable relative abbreviation of the date since last edit or creation
    var timeString: String {
        //RelativeDateTimeFormatter is from the foundation framework and creates
        //  a readable localized strings to represent time between two dates
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated //Sets verbosity of the formatted string.
        //Return a localized string using the formatter for the date passed in
        //  relative to Date
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
    
    
    
    
    
    //Functions
    init(timestamp: Date, title: String, userNote: String, tagGiven: Tags? = nil, isFavorite: Bool = false, isInTrash: Bool = false, latitude: Double?, longitude: Double?, userImages: [Data]?) {
        self.timestamp = timestamp
        self.title = title
        self.userNote = userNote
        self.tagGiven = tagGiven
        self.isFavorite = isFavorite
        self.isInTrash = isInTrash
        self.latitude = latitude
        self.longitude = longitude
        self.userImages = userImages
    }
}



enum SortOrder: String, CaseIterable {
    case title
    case date
    case category
    
    var symbolValue: String {
        switch self {
        case .title:
            "character"
        case .date:
            "calendar"
        case .category:
            "folder"
        }
    }
}

//Extension for Array of Notes for sorting based on enum
extension [Note] {
    func sortByChoice(basedOn: SortOrder) -> [Note] {
        switch basedOn {
        case .date:
            self.sorted(by: { $0.timestamp < $1.timestamp })
        case .title:
            self.sorted(by: { $0.title < $1.title })
        case .category: //category will be optional so this will need guard statements
            self.sorted(by: { $0.timestamp < $1.timestamp })
        }
    }
}
