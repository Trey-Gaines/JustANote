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
    @Query var possibleTags: [Tags]
    @Environment(\.dismiss) private var dismiss
    @Binding var myNewTag: String
    
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
                        addNewTag(myNewTag: myNewTag)
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
    }
    
    private func addNewTag(myNewTag title: String) {
        let myNewTag = Tags(title: title)
        modelContext.insert(myNewTag)
        dismiss()
    }
}
