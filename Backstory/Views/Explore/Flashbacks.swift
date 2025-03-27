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
    @State private var flashbackNameError: String? = nil
    @State private var flashbackDescription = ""
    @State private var flashbackDescriptionError: String? = nil
    @State private var errorString = ""
    @State private var errorThrown = false
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
        flashbackNameError = nil
        flashbackDescriptionError = nil
        errorThrown = false
        
        do {
            try Validation.isRequired(flashbackName, errorVar: &flashbackNameError)
        } catch {
            errorThrown = true
        }
        do {
            try Validation.stringMin(flashbackName, min: 1, errorVar: &flashbackNameError)
        } catch {
            errorThrown = true
        }
        do {
            try Validation.stringMax(flashbackName, max: 100, errorVar: &flashbackNameError)
        } catch {
            errorThrown = true
        }
        do {
            try Validation.isRequired(flashbackDescription, errorVar: &flashbackDescriptionError)
        } catch {
            errorThrown = true
        }
        do {
            try Validation.stringMax(flashbackDescription, max: 1000, errorVar: &flashbackDescriptionError)
        } catch {
            errorThrown = true
        }
        if errorThrown {
            throw ValidationError("Please fix the errors in the form and try again.")
        }
        
    }
    
    
    private func processForm() {
        do {
            try validateForm()
            // look through all the validations and if there are no errors, save the flashback
            
            saveFlashback()
            route = .flashbacks
            toastManager.showToast(message: "Flashback created successfully.")
        } catch let error as BackstoryError {
            toastManager.showToast(message: error.message)
        } catch let error as ValidationError {
            toastManager.showToast(message: error.message)
        } catch {
            print("An unknown error occurred when attempting to validate the form.")
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
                                        

                                    if flashbackNameError != nil {
                                        Text(flashbackNameError ?? "")
                                            .foregroundColor(Stylesheet.Colors.error)
                                            .font(Stylesheet.Fonts.formError)
                                    }
                                }
                                
                                Section(header: Text("Description")) {
                                    TextEditor(text: $flashbackDescription)
                                        .frame(height: 150)
                                        .font(Stylesheet.Fonts.body)
                                        .border(flashbackDescriptionError != nil ? Stylesheet.Colors.error : Color.clear)
                                    if flashbackDescriptionError != nil {
                                        Text(flashbackDescriptionError ?? "")
                                            .foregroundColor(Stylesheet.Colors.error)
                                            .font(Stylesheet.Fonts.formError)
                                    }
                                }
                                
                                
//                                Section(header: Text("Description")) {
//                                    TextEditor(text: $flashbackDescription)
//                                        .frame(height: 150)
//                                        .font(Stylesheet.Fonts.body)
//                                        .border(flashbackDescriptionError != nil ? Color.red : Color.clear)
//                                    if flashbackDescriptionError != nil? {
//                                        Text(flashbackDescriptionError ?? "")
//                                            .foregroundColor(.red)
//                                            .font(Stylesheet.Fonts.body)
//                                    }
//                                    
//                                }
                                
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
