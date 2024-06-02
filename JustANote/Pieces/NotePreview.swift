//
//  NotePreview.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import SwiftUI

struct NotePreview: View {
    var currentNote: Note
    @Environment(\.colorScheme) private var colorScheme 
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(currentNote.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(currentNote.shortNote)
                        .fontWeight(.ultraLight)
                        .lineLimit(2)
                }
                .padding(.all, 0)
                Spacer()
                
                VStack {
                    // If For Map
                    if currentNote.latitude != nil || currentNote.longitude != nil {
                        Text("You got data!")
                    }
                    
                    // If For Images
                    if let imageData = currentNote.userImages?.first, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 200, maxHeight: 200)
                    }
                }
            }
            Text(currentNote.timeString)
                .font(.footnote)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    NotePreview(currentNote: Note(timestamp: Date.distantPast,
                                  title: "My Favorite Note", 
                                  userNote: "My favorite thing to do is win",
                                  latitude: nil, longitude: nil, userImages: nil))
}
