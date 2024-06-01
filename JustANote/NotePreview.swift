//
//  NotePreview.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import SwiftUI

struct NotePreview: View {
    var currentNote: Note
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct NotePreview_Previews: PreviewProvider {
    static var previews: some View {
        let mockNote = Note(
            timestamp: Date(),
            title: "Hello, World!",
            userNote: "This is a note about our world",
            latitude: 40.7128,
            longitude: -74.0060,
            userImages:  []
        )
        NotePreview(currentNote: mockNote)
    }
}
