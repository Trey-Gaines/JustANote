//
//  JustANoteApp.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import SwiftUI
import SwiftData

@main
struct JustANoteApp: App {
    @State private var myNoteObject = NoteRecorded()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
            //Tags.self     *Because Note.self has an inverse relationship to Tags, I don't think this is needed...
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environment(myNoteObject)
    }
}
