//
//  DetailedNoteView.swift
//  JustANote
//
//  Created by Trey Gaines on 6/1/24.
//

import SwiftUI
import SwiftData
import Foundation
import MapKit

struct DetailedNoteView: View {
    //Instead of using Bindable with the SwiftData Object, instead make current note optional, and use the observable object to monitor changes & update
    //For instance, onAppear if currentNote is nil then use an empty Observable object to record all the user inputs and create a new note object
    // if currentNote isn't nil, use the other init to create an object with all the values that are bindable, and before dismiss update the note and then deinit
    
    
    @Bindable var currentNote: NoteRecorded
    @State private var newTitle: String = ""
    var isNewNote: Bool
    @State private var createNewTag: Bool = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @Query private var possibleTags: [Tags]
    @State private var myTag: Tags?
    @State private var myNewTag = ""
    @State private var myLocation: CLLocation?
    private let defaultCameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    
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
                } //Title
                
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
                                    currentNote.tagGiven = matchingTag
                                }
                            }
                        } //Check both because while the picker was set after NewTag was created, myTag wasn't
                        .onChange(of: createNewTag) {
                            if createNewTag == false {
                                if let matchingTag = possibleTags.first(where: { $0.title == myNewTag }) {
                                    myTag = matchingTag
                                    currentNote.tagGiven = matchingTag
                                }
                            }
                        }
                        .cornerRadius(8)
                    } label: {
                        HStack {
                            Image(systemName: "tag")
                                .font(.footnote)
                                .fontWeight(.semibold)
                            Text(myNewTag)
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
                } //Tag
                
                HStack {
                    Text(currentNote.formattedDate)
                        .fontWeight(.ultraLight)
                        .font(.footnote)
                } //Date
                
                HStack(alignment: .center) {
                    if myLocation != nil && isNewNote {
                        let coordinate = CLLocationCoordinate2D(latitude: myLocation!.coordinate.latitude, longitude: myLocation!.coordinate.longitude)
                        let userCameraPosition = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006))
                        let position = MapCameraPosition.region(userCameraPosition)
                        
                        VStack {
                            Map(position: .constant(position)) {
                                Annotation("", coordinate: coordinate, anchor: .bottom) {
                                    Image(systemName: "pin.fill")
                                        .foregroundColor(.white)
                                        .background(.blue)
                                        .cornerRadius(6)
                                        .padding()
                                }
                            }
                            .mapStyle(.hybrid)
                            .frame(width: 125, height: 125)
                            .cornerRadius(15)
                        }
                    } else if currentNote.latitude != nil && currentNote.longitude != nil {
                        let coordinate = CLLocationCoordinate2D(latitude: currentNote.latitude!, longitude: currentNote.longitude!)
                        let userCameraPosition = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006))
                        let position = MapCameraPosition.region(userCameraPosition)
                        
                        VStack {
                            Map(position: .constant(position)) {
                                Annotation("", coordinate: coordinate, anchor: .bottom) {
                                    Image(systemName: "pin.fill")
                                        .foregroundColor(.white)
                                        .background(.blue)
                                        .cornerRadius(6)
                                        .padding(.all, 4)
                                }
                            }
                            .mapStyle(.hybrid)
                            .frame(width: 125, height: 125)
                            .cornerRadius(15)
                        }
                    } else {
                        ZStack {
                            Map(initialPosition: defaultCameraPosition)
                                .mapStyle(.hybrid)
                                .frame(width: 125, height: 125)
                                .cornerRadius(15)
                            
                            Text("No Location Added")
                                .font(.title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: 125, height: 125)
                                .background(Material.ultraThinMaterial.opacity(0.95))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                    Spacer()
                    LazyHStack {
                        //                        ForEach(currentNote.userImages, id: \.self) { image in
                        //                            Image(uiImage: <#T##UIImage#>)
                        //                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 150)
                .clipped()
                .padding(.horizontal)
                
                
                //For Location and Images
                
            }
            
            
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
                            //modelContext.delete(currentNote)
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
                    .frame(maxWidth: .infinity, minHeight: 300)
                    .padding(.horizontal)
            }
            .overlay {
                if currentNote.userNote == "" {
                    Text("Leave a Note")
                        .font(.body)
                        .fontWeight(.bold)
                        .opacity(0.2)
                        .offset(y: -180)
                }
            }
            
            HStack {
                if isNewNote {
                    Button {
                        print("Yes")
                    } label: {
                        VStack {
                            Image(systemName: "photo.circle.fill")
                            Text("Add photos")
                        }
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.blue.opacity(0.1))
                                .shadow(radius: 5)
                                .font(.footnote)
                        )
                    }
                    .padding(.all, 1)
                }
                Spacer()
                if isNewNote {
                        Button {
                            let myNewNote = Note(timestamp: Date(), title: currentNote.title, userNote: currentNote.userNote, tagGiven: myTag, latitude: myLocation?.coordinate.latitude, longitude: myLocation?.coordinate.longitude)
                            modelContext.insert(myNewNote)
                            dismiss()
                            
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                        }
                        .disabled(currentNote.title != "" && currentNote.userNote != "")
                    
                } else {
                    Button {
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
                        CLLocationManager().requestWhenInUseAuthorization()
                        if let userCoordinate = CLLocationManager().location {
                            myLocation = userCoordinate
                        }
                    } label: {
                        VStack {
                            Image(systemName: "location.circle.fill")
                            Text("Add location")
                        }
                        .fontWeight(.semibold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.blue.opacity(0.1))
                                .shadow(radius: 5)
                        )
                    }
                    .font(.footnote)
                    .padding(.all, 1)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
        .onAppear {
            if isNewNote {
                myTag = nil
                myNewTag = "Select a Tag"
            }
            else if currentNote.tagGiven != nil {
                myNewTag = currentNote.tagGiven!.title
            } else {
                myNewTag = "Select a Tag"
            }
            
            if isNewNote {
                
            }
        }
    }
    
    private func addNewTag(myNewTag title: String) {
        let myNewTag = Tags(title: title)
        modelContext.insert(myNewTag)
    }
}


