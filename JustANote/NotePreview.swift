//
//  NotePreview.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import SwiftUI

struct NotePreview: View {
    @Environment(\.modelContext) private var modelContext
    @State var currentNote: Note
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    NotePreview(currentNote: Note.init(timestamp: 
                                        Date.now, title: "Yes", userNote: "YesYesYes"))
    .modelContainer(for: Item.self, inMemory: true)
}
