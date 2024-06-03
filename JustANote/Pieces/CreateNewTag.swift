//
//  CreateNewTag.swift
//  JustANote
//
//  Created by Trey Gaines on 6/2/24.
//

import SwiftUI
import SwiftData

struct CreateNewTag: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query var possibleTags: [Tags]
    @Binding var myNewTag: String
    @Binding var myBool: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            Text("Add New Tag")
                .font(.title)
                .fontWeight(.semibold)
            TextField("Enter the name of new Tag", text: $myNewTag)
                .multilineTextAlignment(.center)
                .padding()
            HStack {
                Spacer()
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                }
                Spacer()
                
                if myNewTag != "" && myNewTag.lowercased() != ("New Tag").lowercased() && !possibleTags.contains(where: {$0.title.lowercased() == myNewTag.lowercased()}) {
                    Button {
                        addNewTag(newTag: myNewTag)
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
        }
        .onAppear {
            myNewTag = ""
        }
    }
    
    private func addNewTag(newTag title: String) {
        let newTag = Tags(title: title)
        modelContext.insert(newTag)
        myBool = false
    }
}
