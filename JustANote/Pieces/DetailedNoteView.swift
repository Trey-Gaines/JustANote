//
//  DetailedNoteView.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import SwiftUI
import SwiftData
import Foundation

struct DetailedNoteView: View {
    @Bindable var currentNote: Note
    var isNewNote: Bool
    @State private var createNewTag: Bool = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var possibleTags: [Tags]
    @State private var myTag: Tags?
    @State private var myNewTag = ""
              
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                HStack {
                    TextField("Enter A Title", text: $currentNote.title)
                        .background(Color.clear)
                        .multilineTextAlignment(.center)
                        .cornerRadius(5)
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                }
                
                HStack {
                    Menu {
                        Picker("Select a Tag", selection: $myNewTag) {
                            ForEach(possibleTags, id: \.self) { tag in
                                Text(tag.title).tag(tag.title)
                            }
                            Text("New Tag").tag("")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: myNewTag) {
                            if myNewTag == "" {
                                createNewTag = true
                            } else {
                                if let matchingTag = possibleTags.first(where: { $0.title == myNewTag }) {
                                    myTag = matchingTag
                                }
                            }
                        } //Check both because while the picker was set after NewTag was created, myTag wasn't
                        .onChange(of: createNewTag) {
                            if createNewTag == false {
                                if let matchingTag = possibleTags.first(where: { $0.title == myNewTag }) {
                                    myTag = matchingTag
                                }
                            }
                        }
                        .cornerRadius(8)
                    } label: {
                        HStack {
                            Image(systemName: "tag")
                                .font(.footnote)
                                .fontWeight(.semibold)
                            Text(myTag?.title ?? "Select A Tag")
                                .fontWeight(.semibold)
                                .font(.footnote)
                        }
                        .padding(.all, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.blue.opacity(0.1))
                                .shadow(radius: 5)
                        )
                    }
                }
                
                
                HStack {
                    Text(currentNote.formattedDate)
                        .fontWeight(.ultraLight)
                        .font(.footnote)
                }
                HStack {
                    EmptyView()
                }
            }
            .padding()
            
            .sheet(isPresented: $createNewTag) {
                CreateNewTag(myNewTag: $myNewTag, myBool: $createNewTag)
                .padding()
                .presentationDetents([.height(135), .height(150)])
            }
            
            if currentNote.isInTrash { //Gives User ability to recover note from trash
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            currentNote.isInTrash.toggle()
                            dismiss()
                        }
                    } label: {
                        Label("Recover", systemImage: "trash.slash")
                    }
                    Spacer()
                    Button(role: .destructive) {
                        withAnimation {
                            modelContext.delete(currentNote)
                            dismiss()
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    Spacer()
                }
                .padding(.bottom, 5)
            }
            
            ScrollView {
                TextEditor(text: $currentNote.userNote)
                    .background(Color.clear)
                    .cornerRadius(5)
                    .font(.body)
                    .frame(maxWidth: .infinity, minHeight: 450)
                    .padding(.horizontal)
            }
            .overlay {
                if currentNote.userNote == "" {
                    Text("Leave a Note")
                        .font(.body)
                        .fontWeight(.bold)
                        .opacity(0.2)
                        .offset(y: -240)
                }
            }
            
            HStack {
                if isNewNote {
                    Button {
                        print("Yes")
                    } label: {
                        Image(systemName: "photo.circle.fill")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
                if isNewNote == true {
                    if currentNote.title != "" && currentNote.userNote != "leave a new note" {
                        Button {
                            let myNewNote = Note(timestamp: Date(), title: currentNote.title, userNote: currentNote.userNote, tagGiven: myTag, latitude: currentNote.latitude, longitude: currentNote.longitude, userImages: currentNote.userImages)
                            
                            modelContext.insert(myNewNote)
                            dismiss()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                        }
                    } else {
                        Button(role: .destructive) {
                            dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                } else {
                    Button {
                        currentNote.tagGiven = myTag
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
                if isNewNote {
                    Button {
                        print("Yes")
                    } label: {
                        Image(systemName: "location.circle.fill")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
        .onAppear {
            if currentNote.tagGiven != nil {
                myNewTag = currentNote.tagGiven!.title
            } else {
                myNewTag = "Select A Tag"
            }
            if isNewNote {
                currentNote.title = ""
                currentNote.userNote = ""
                currentNote.timestamp = Date()
                currentNote.latitude = nil
                currentNote.tagGiven = nil
                currentNote.longitude = nil
                currentNote.userImages = nil
                currentNote.isFavorite = false
                currentNote.isInTrash = false
            }
        }
    }
    
    private func addNewTag(myNewTag title: String) {
        let myNewTag = Tags(title: title)
        modelContext.insert(myNewTag)
    }
}


