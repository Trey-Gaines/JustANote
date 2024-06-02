//
//  ContentView.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Note> { note in //filter out all trashed notes
        !note.isInTrash }) private var notes: [Note]
    @State private var searchQuery: String = ""
    @State private var selectedSort = SortOrder.allCases.first! //Dictates sort order
    @State private var searchingTrash: Bool = false
    @State private var isPresentingDetailView = false
    @State private var showFavorites: Bool = true
    
    let newNote = Note(timestamp: Date(), title: "", userNote: "leave a note", latitude: nil, longitude: nil, userImages: nil)
    
    var formattedNotes: [Note] {
        if searchQuery == "" {
            let nonFavoriteFormatted = notes.compactMap { note in
                return note.isFavorite ? nil : note
            }
            
            return nonFavoriteFormatted.sortByChoice(basedOn: selectedSort)
        }
        let filteredNotes = notes.compactMap { note in
            //Bool for title match
            let titleMatch = note.title.range(of: searchQuery, options: .caseInsensitive) != nil
            
            //Bool for title match
            let categoryMatch = false //note.category.ranges(of: searchQuery, options: .caseInsensitive) != nil
            
            //Compact map eliminates all nil values, so if there's a title
            //  or category match return the note else return nil
            return (titleMatch || categoryMatch) ? note : nil
        }
        return filteredNotes.sortByChoice(basedOn: selectedSort)
    }
    
    var favoriteNotes: [Note] {
        let favoriteNotes = notes.compactMap { note in
            return note.isFavorite ? note : nil
        }
        
        return favoriteNotes.sortByChoice(basedOn: selectedSort)
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if searchQuery == "" && !favoriteNotes.isEmpty {
                        Section(header: Text("Favorites")) {
                            ForEach(favoriteNotes) { note in
                                NavigationLink(destination: DetailedNoteView(currentNote: note)) {
                                    NotePreview(currentNote: note)
                                        .padding(.horizontal, 10)
                                        .padding(.bottom, 2)
                                        .swipeActions {
                                            Button(role: .destructive) {
                                                note.isFavorite.toggle()
                                            } label: {
                                                Label("Unfavorite", systemImage: "star.fill")
                                            }
                                        }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("All Notes")) {
                        ForEach(formattedNotes) { note in
                            NavigationLink(destination: DetailedNoteView(currentNote: note)) {
                                NotePreview(currentNote: note)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 2)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            note.isInTrash.toggle()
                                        } label: {
                                            Label("Trash", systemImage: "trash.fill")
                                        }
                                        
                                        Button(role: .cancel) {
                                            note.isFavorite.toggle()
                                        } label: {
                                            Label("Favorite", systemImage: "star.fill")
                                        }
                                    }
                            }
                        }
                    }
                }
                HStack{
                    Button {
                        searchingTrash.toggle()
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                    .padding(.all, 1)
                }
            }
            .sheet(isPresented: $searchingTrash) {
                TrashView()
                    .presentationDetents([.medium, .large])
            }
            .toolbar {
                //Button to add new note
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: NewNoteView(), label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    })
                    .navigationBarHidden(true)
                }
                
                //Title Text View
                ToolbarItem(placement: .principal) {
                    HStack {
                        Spacer()
                        Text("My Notes")
                            .font(.system(size: 25))
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                
                //Button to change sort order
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("", selection: $selectedSort) {
                            ForEach(SortOrder.allCases, id: \.rawValue) { order in
                                Label(order.rawValue.capitalized, systemImage: order.symbolValue)
                                    .tag(order)
                            }
                        }
                    } label: {
                        Image(systemName: "rectangle.stack")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}
