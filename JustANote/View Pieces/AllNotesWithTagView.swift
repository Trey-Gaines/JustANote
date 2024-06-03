//
//  AllNotesWithTagView.swift
//  JustANote
//
//  Created by Trey Gaines on 6/3/24.
//

import SwiftUI
import SwiftData

struct AllNotesWithTagView: View {
    var myTag: Tags
    private var myNotes: [Note]? {
        myTag.notes
    }

    var body: some View {
        VStack {
            HStack {
                Text("All notes under")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                Text("#\(myTag.title)")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                    .multilineTextAlignment(.center)
            }
            List {
                ForEach(myNotes ?? []) { note in
                    NotePreview(currentNote: note)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 2)
                        .swipeActions {
                            Button(role: .destructive) {
                                note.tagGiven = nil
                            } label: {
                                Label("Remove Tag", systemImage: "tag.slash.fill")
                            }
                        }
                }
            }
        }
    }
}

