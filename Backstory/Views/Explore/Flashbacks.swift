//
//  Flashbacks.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/23/25.
//

import SwiftUI

struct FlashbacksView: View {
    
    @State private var route: FlashbacksRoute = .flashbacks
    @State private var flashbackDate = Date()
    @State private var flashbackName = ""
    @State private var flashbackNameError = ""
    @State private var flashbackDescription = ""
    @State private var flashbackDescriptionError = ""
    @EnvironmentObject var toastManager: ToastManager
    
    enum FlashbacksRoute {
        case flashbacks // list all
        case createFlashback
    }
    
    private func saveFlashback() {
        FlashbackManager.shared.createFlashback(name: flashbackName, desc: flashbackDescription, date_unix: Int32(flashbackDate.timeIntervalSince1970))
        toastManager.showToast(message: "Flashback created successfully.")
        route = .flashbacks
       
    }
    
    private func validateForm() throws {
        do {
            try Validation.isString(flashbackName)
            try Validation.isRequired(flashbackName)
            try Validation.stringMin(flashbackName, min: 3)
            try Validation.stringMax(flashbackName, max: 10)
        } catch let error as ValidationError {
            throw BackstoryError(message: error.localizedDescription)
        }
    }
    
    private func processForm() {
        do {
            try validateForm()
            toastManager.showToast(message: "Form is valid.")
            // saveFlashback()
        } catch let backstoryError as BackstoryError {
            toastManager.showToast(message: backstoryError.message)
        } catch {
            toastManager.showToast(message: "An error occurred when attempting to validate the form.")
        }
    }
    
    var body: some View {
        
        
        
        VStack {
            VStack {
                switch route {
                case .flashbacks:
                    HStack {
                        Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                            .font(Stylesheet.Fonts.heading3)
                            .foregroundColor(Stylesheet.Colors.heading2)
                        Text("Flashbacks")
                            .font(Stylesheet.Fonts.heading3)
                            .foregroundColor(Stylesheet.Colors.heading2)
                            
                    }
                    .padding()
                    .padding(.leading, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    NavigationStack {
                        List {
                            Button(action: {
                                route = .createFlashback
                            }) {
                                MenuItemView(title: "Create Flashback")
                            }
                            
                            let flashbacks = FlashbackManager.shared.fetchFlashbacks()
                            ForEach(flashbacks) { flashback in
                                Button(action: {
                                    //
                                }) {
                                    MenuItemView(title: flashback.name ?? "No Name")
                                }
                                
                            }
                            
                            
                        }
                        .listStyle(.inset)
                    }
                    .navigationTitle("Flashbacks")
                    Spacer()
                case .createFlashback:
                    VStack {
                        VStack {
                            Button(action: {
                                route = .flashbacks
                            }) {
                                BackLink(text: "< Back")
                            }
                            HStack {
                                
                                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                                    .font(Stylesheet.Fonts.heading3)
                                    .foregroundColor(Stylesheet.Colors.heading2)
                                Text("Create Flashback")
                                    .font(Stylesheet.Fonts.heading3)
                                    .foregroundColor(Stylesheet.Colors.heading2)
                            }
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(10)
                        
                        VStack {
                            Form {
                                Section(header: Text("Name")) {
                                    TextField("Name", text: $flashbackName)
                                        .font(Stylesheet.Fonts.body)
                                    Text(flashbackNameError)
                                        .foregroundColor(.red)
                                        .font(Stylesheet.Fonts.body)
                                }
                                Section(header: Text("Description")) {
                                    TextEditor(text: $flashbackDescription)
                                        .frame(height: 150)
                                        .font(Stylesheet.Fonts.body)
                                    Text(flashbackNameError)
                                        .foregroundColor(.red)
                                        .font(Stylesheet.Fonts.body)
                                }
                                
                            }
                            FormButton(title: "Create", action: {
                                //saveFlashback()
                                processForm()
                            })
                            .padding()
                            Spacer()
                        }
                        Spacer()
                    }
                    Spacer()
                    //.padding()
                    
                }
                
                // Add more content for the Flashbacks view here
            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
        
        
    }
}

struct FlashbacksView_Previews: PreviewProvider {
    static var previews: some View {
        FlashbacksView()
    }
}
