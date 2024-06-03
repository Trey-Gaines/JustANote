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
        VStack {
            HStack(alignment: .center) {
                Text(currentNote.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .center) {
                Text(currentNote.shortNote)
                    .fontWeight(.ultraLight)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Spacer()
                Text("#\(currentNote.tagGiven?.title ?? "N/A")")
                    .font(.footnote)
                    .foregroundStyle(.blue)
                HStack {
                    Spacer()
                    if currentNote.latitude != nil {
                        Image(systemName: "mappin.circle")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    if currentNote.userImages != nil {
                        Image(systemName: "photo.artframe.circle")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                Text(currentNote.timeString)
                    .font(.footnote)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NotePreview(currentNote: Note(timestamp: Date.distantPast,
                                  title: "My Favorite Note is this one",
                                  userNote: "My favorite thing to do is win. There are no other pleasantries. I just want to win, that's it for me. I like to",
                                  tagGiven: nil, latitude: nil, longitude: nil, userImages: nil))
}
