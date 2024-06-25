//
//  Note.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import Foundation
import SwiftData
import _MapKit_SwiftUI
import Observation

@Model
class Note: Identifiable {
    var id = UUID()
    var timestamp: Date = Date.now
    var title: String = ""
    var userNote: String = ""
    var latitude: Double?
    var longitude: Double?
    //var userImages: [Data]?
    var isFavorite: Bool = false
    var isInTrash: Bool = false
    var lastModified: Date = Date.now
    
    
    
    
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
        //Limit string to first 80 characters
        let trimmedNote = userNote.prefix(75)
        
        //Replace newlines & trim whitespaces within new substring
        let cleanedNote = trimmedNote
            .replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Add continuation (ellipses) if needed
        if userNote.count > 75 {
            return cleanedNote + "..."
        } else {
            return cleanedNote
        }
    }
    
    //Shorthands the title for preview
    var shortTitle: String {
        if title.count > 10 {
            //set a string index, offset the startIndex by 20
            let index = title.index(title.startIndex, offsetBy: 10)
            //Create a substring from start to index, convert it to string
            //     and then trim the whitespaces and add "..."
            return String(title[..<index]).trimmingCharacters(in: .whitespacesAndNewlines) + "..."
        } else {
            return title
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
    init(timestamp: Date = Date.now, title: String, userNote: String, tagGiven: Tags? = nil, isFavorite: Bool = false,
         isInTrash: Bool = false, latitude: Double?, longitude: Double?, lastModified: Date = Date.now) {
        self.timestamp = timestamp
        self.title = title
        self.userNote = userNote
        self.tagGiven = tagGiven
        self.isFavorite = isFavorite
        self.isInTrash = isInTrash
        self.latitude = latitude
        self.longitude = longitude
        self.lastModified = lastModified
    }
    
    func setLocation(from location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
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
        case .category:
            self.sorted(by: {
                guard let itemACategory = $0.tagGiven?.title, let itemBCategory = $1.tagGiven?.title
                else { return false }
                return itemACategory < itemBCategory
            })
        }
    }
}






@Observable
class NoteRecorded {
    var timestamp: Date
    var title: String
    var userNote: String
    var latitude: Double? // Store latitude
    var longitude: Double? // Store longitude
    var isFavorite: Bool
    var isInTrash: Bool
    var tagGiven: Tags?
    var lastModified: Date
    
    init(timestamp: Date, title: String, userNote: String, latitude: Double? = nil, longitude: Double? = nil, isFavorite: Bool, isInTrash: Bool, lastModified: Date) {
        self.timestamp = timestamp
        self.title = title
        self.userNote = userNote
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
        self.isInTrash = isInTrash
        self.lastModified = lastModified
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: timestamp)
    }
    
    convenience init(note: Note) {
        self.init(timestamp: note.timestamp, title: note.title, userNote: note.userNote, latitude: note.latitude, longitude: note.longitude, isFavorite: note.isFavorite, isInTrash: note.isInTrash, lastModified: note.lastModified)
    }
    
    convenience init() {
        self.init(timestamp: .now, title: "", userNote: "", latitude: nil, longitude: nil, isFavorite: false, isInTrash: false, lastModified: .now)
    }
    
    
    deinit {
        print("Note Recorded has been reset")
    }
}
