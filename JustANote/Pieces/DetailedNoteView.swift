//
//  DetailedNoteView.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import SwiftUI

struct DetailedNoteView: View {
    @Bindable var currentNote: Note
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            VStack {
                VStack(alignment: .center) {
                    TextField("Enter A Title", text: $currentNote.title)
                        .background(Color.clear)
                        .multilineTextAlignment(.center)
                        .cornerRadius(5)
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Text(currentNote.formattedDate)
                        .fontWeight(.ultraLight)
                        .font(.footnote)
                    HStack {
                        EmptyView()
                    }
                }
                .padding()
                if currentNote.isInTrash {
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
                        .frame(maxWidth: .infinity, minHeight: 600)
                        .padding(.horizontal)
                }
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
    }
}
