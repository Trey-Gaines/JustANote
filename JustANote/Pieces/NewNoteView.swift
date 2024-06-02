//
//  NewNoteView.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import SwiftUI
import Foundation

struct NewNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    //Creating a new Object
    @State var myTitle: String = ""
    @State var myNote: String = ""

    
    var body: some View {
            VStack {
                VStack(alignment: .center) {
                    TextField("Enter A Title", text: $myTitle)
                        .background(Color.clear)
                        .multilineTextAlignment(.center)
                        .cornerRadius(5)
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Text(DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none))
                        .fontWeight(.ultraLight)
                        .font(.footnote)
                    HStack {
                        EmptyView()
                    }
                }
                .padding()
                ScrollView {
                    TextEditor(text: $myNote)
                        .background(Color.clear)
                        .cornerRadius(5)
                        .font(.body)
                        .frame(maxWidth: .infinity, minHeight: 600)
                        .padding(.horizontal)
                }
                HStack {
                    //Button to add images
                    Button {
                        print("Yes")
                    } label: {
                        Image(systemName: "photo.circle.fill")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                    Spacer()
                    //Button to save and dismiss
                    if myTitle != "" && myNote != "" {
                        Button {
                            let myNewNote = Note(timestamp: Date(), title: myTitle, userNote: myNote, latitude: nil, longitude: nil, userImages: nil)
                            modelContext.insert(myNewNote)
                            dismiss()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                        }
                    }
                    Spacer()
                    //Button to add location
                    Button {
                        print("Yes")
                    } label: {
                        Image(systemName: "location.circle.fill")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
    }
}

