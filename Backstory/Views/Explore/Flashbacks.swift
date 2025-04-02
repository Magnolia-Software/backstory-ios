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
        
        let fields: [(value: String, errorVar: (inout String?) -> Void, rules: [(String, inout String?) throws -> Void])] = [
            (value: flashbackName, errorVar: { self.flashbackNameError = $0 }, rules: [
                Validation.isRequired,
                { try Validation.stringMin($0, min: 1, errorVar: &$1) },
                { try Validation.stringMax($0, max: 100, errorVar: &$1) }
            ]),
            (value: flashbackDescription, errorVar: { self.flashbackDescriptionError = $0 }, rules: [
            { try Validation.stringMax($0, max: 1000, errorVar: &$1) }
            ])
        ]
        
        try ValidationManager.validate(fields: fields)
    }
    
    private func processForm() {
        do {
            try validateForm()
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
                            })  {
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
                    PageWrapperView(
                        title: "Create Flashback",
                        breadcrumbs: [
                            Breadcrumb(title: "Flashbacks") { route = .flashbacks }
                        ]
                    ) {
                        FormBuilder(
                            fields: [
                                Field(
                                    type: .textField,
                                    title: "Name",
                                    binding: $flashbackName,
                                    errorBinding: $flashbackNameError,
                                    validationRules: [
                                        Validation.isRequired,
                                        { try Validation.stringMin($0, min: 1, errorVar: &$1) },
                                        { try Validation.stringMax($0, max: 100, errorVar: &$1) }
                                    ]
                                ),
                                Field(
                                    type: .textEditor,
                                    title: "Description",
                                    binding: $flashbackDescription,
                                    errorBinding: $flashbackDescriptionError,
                                    validationRules: [
                                        Validation.isRequired,
                                        { try Validation.stringMax($0, max: 1000, errorVar: &$1) }
                                    ]
                                )
                            ],
                            onSubmit: { processForm() }
                        )
                    }
                }
                
            }
            .background(Color.white)
        }
        
        
    }
}

struct FlashbacksView_Previews: PreviewProvider {
    static var previews: some View {
        FlashbacksView()
    }
}
