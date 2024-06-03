//
//  tagView.swift
//  JustANote
//
//  Created by Trey Gaines on 6/2/24.
//

import SwiftUI
import SwiftData

struct myTagView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var possibleTags: [Tags]
    @State private var newTagView: Bool = false
    @State var newTagName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("All Tags")) {
                        ForEach(possibleTags) { tag in
                            HStack {
                                Text(tag.title)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(tag.notes?.count ?? 0)")
                                    .fontWeight(.light)
                            }
                            
                            .padding(.horizontal, 10)
                            .padding(.bottom, 2)
                            .swipeActions {
                                Button(role: .destructive) {
                                    modelContext.delete(tag)
                                } label: {
                                    Label("Trash", systemImage: "trash.fill")
                                }
                            }
                        }
                    }
                    
                }
                
                VStack {
                    Button {
                        newTagView = true
                    } label: {
                        VStack {
                            Image(systemName: "tag.fill")
                            Text("Create a Tag")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.blue.opacity(0.1))
                                .shadow(radius: 5)
                        )
                    }
                }
            }
            .padding()
            .sheet(isPresented: $newTagView) {
                CreateNewTag(myNewTag: $newTagName, myBool: $newTagView)
                    .padding()
                    .presentationDetents([.height(135), .height(150)])
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Tag Settings")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .padding(.all, 2)
                            .padding(.top, 50)
                        Text("Create or Delete tags")
                            .font(.footnote)
                            .opacity(0.2)
                    }
                }
                
            }
        }
        
    }
}

#Preview {
    myTagView()
        .modelContainer(for: Note.self, inMemory: true)
}
