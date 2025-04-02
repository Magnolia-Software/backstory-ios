//
//  FormWrapper.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/31/25.
//

import SwiftUI

enum FieldType {
    case textField
    case textEditor
}

struct Field {
    let type: FieldType
    let title: String
    let binding: Binding<String>
    let errorBinding: Binding<String?>
    let validationRules: [(String, inout String?) throws -> Void]
}

struct FormBuilder: View {
    let fields: [Field]
    let onSubmit: () -> Void
    @EnvironmentObject var toastManager: ToastManager
    
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            VStack {
                Form {
                    ForEach(fields.indices, id: \.self) { index in
                        switch fields[index].type {
                        case .textField:
                            Section(header: Text(fields[index].title)) {
                                TextField(fields[index].title, text: fields[index].binding)
                                    .font(Stylesheet.Fonts.body)
                                if let error = fields[index].errorBinding.wrappedValue {
                                    Text(error)
                                        .foregroundColor(Stylesheet.Colors.error)
                                        .font(Stylesheet.Fonts.formError)
                                }
                            }
                        case .textEditor:
                            Section(header: Text(fields[index].title)) {
                                TextEditor(text: fields[index].binding)
                                    .frame(height: 150)
                                    .font(Stylesheet.Fonts.body)
                                
                                if let error = fields[index].errorBinding.wrappedValue {
                                    Text(error)
                                        .foregroundColor(Stylesheet.Colors.error)
                                        .font(Stylesheet.Fonts.formError)
                                }
                            }
                        }
                    }
                    
                }
                
                if errorMessage != "" {
                    Text(errorMessage ?? "")
                        .foregroundColor(Stylesheet.Colors.error)
                }
                
                FormButton(title: "Create", action: {
                    do {
                        try validateFields()
                        onSubmit()
                    } catch let error as ValidationError {
                        errorMessage = error.message
                        toastManager.showToast(message: errorMessage ?? "")
                        // scroll to top of form
                        
                    } catch {
                        errorMessage = "An unknown error occurred."
                        toastManager.showToast(message: errorMessage ?? "")
                    }
                })
                .padding()
                Spacer()
            }
            Spacer()
        }
    }
    
    private func validateFields() throws {
        var errorThrown = false
        
        for field in fields {
            var errorVar: String? = nil
            do {
                try Validation.runValidationRules(rules: field.validationRules, value: field.binding.wrappedValue, errorVar: &errorVar)
            } catch {
                errorThrown = true
            }
            field.errorBinding.wrappedValue = errorVar
        }
        
        if errorThrown {
            throw ValidationError("Please fix the errors in the form and try again.")
        }
    }
}
