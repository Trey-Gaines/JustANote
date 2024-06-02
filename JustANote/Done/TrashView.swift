//
//  TrashView.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import SwiftUI
import SwiftData

struct TrashView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Note> { note in
        note.isInTrash
    }, sort: \Note.title) private var notes: [Note]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Trash")
                        .font(.system(size: 25))
                        .fontWeight(.semibold)
                        .padding()
                }
                List {
                    ForEach(notes) { note in
                        NavigationLink(destination: DetailedNoteView(currentNote: note)) {
                            NotePreview(currentNote: note)
                        }
                    }
                }
            }
        }
    }
    
    private func deleteNote(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(notes[index])
            }
        }
    }
}