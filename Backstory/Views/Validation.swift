//
//  Validation.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/24/25.
//

import Foundation
import SwiftUI
import Combine
//
///// A protocol that defines a validation rule for a specific type of input.
//protocol ValidationRule {
//    associatedtype Input
//    
//    /// Validates the given input.
//    /// - Parameter input: The input to validate.
//    /// - Returns: An optional error message if validation fails.
//    func validate(_ input: Input) -> String?
//}
//
//import Foundation
//
///// A type-erased wrapper for any ValidationRule.
//struct AnyValidationRule<Input>: ValidationRule {
//    private let _validate: (Input) -> String?
//    
//    /// Initializes the type-erased validation rule with a specific ValidationRule.
//    /// - Parameter rule: The validation rule to wrap.
//    init<R: ValidationRule>(_ rule: R) where R.Input == Input {
//        self._validate = rule.validate
//    }
//    
//    /// Validates the input using the encapsulated validation rule.
//    /// - Parameter input: The input to validate.
//    /// - Returns: An optional error message if validation fails.
//    func validate(_ input: Input) -> String? {
//        return _validate(input)
//    }
//}
//
//// Validation rule to check if a string is not empty.
//struct EmptyValidationRule: ValidationRule {
//    typealias Input = String
//    
//    let errorMessage: String
//    
//    // Initializes the EmptyValidationRule with a custom error message.
//    init(errorMessage: String = "This field cannot be empty.") {
//        self.errorMessage = errorMessage
//    }
//    
//    func validate(_ input: String) -> String? {
//        print("Validating Empty: \(input)")
//        return input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? errorMessage : nil
//    }
//}
//
//// Validation rule to check if a string contains at least one special character.
//struct SpecialCharacterValidationRule: ValidationRule {
//    typealias Input = String
//    
//    let errorMessage: String
//    
//    // Initializes the SpecialCharacterValidationRule with a custom error message.
//    init(errorMessage: String = "Password must contain at least one special character.") {
//        self.errorMessage = errorMessage
//    }
//    
//    func validate(_ input: String) -> String? {
//        print("Validating Special Character: \(input)")
//        let specialCharacterRegex = #".*[!@#$%^&*(),.?":{}|<>].*"#
//        let predicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
//        return predicate.evaluate(with: input) ? nil : errorMessage
//    }
//}
//
//// Validation rule to check if a string is a valid email address.
//struct EmailValidationRule: ValidationRule {
//    typealias Input = String
//    
//    let errorMessage: String
//    
//    // Initializes the EmailValidationRule with a custom error message.
//    init(errorMessage: String = "Please enter a valid email address.") {
//        self.errorMessage = errorMessage
//    }
//    
//    func validate(_ input: String) -> String? {
//        print("Validating Email: \(input)")
//        // Simple regex for demonstration purposes.
//        let emailRegex = #"^\S+@\S+\.\S+$"#
//        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return predicate.evaluate(with: input) ? nil : errorMessage
//    }
//}
//
//// Validation rule to check if a string does not exceed a maximum length.
//struct MaxLengthValidationRule: ValidationRule {
//    typealias Input = String
//    
//    let maxLength: Int
//    let errorMessage: String
//    
//    init(maxLength: Int, errorMessage: String) {
//        self.maxLength = maxLength
//        self.errorMessage = errorMessage
//    }
//    
//    func validate(_ input: String) -> String? {
//        print("Validating Max Length: \(input)")
//        return input.count > maxLength ? errorMessage : nil
//    }
//}
//
///// A view model that handles validation for a specific input.
//class ValidatedField: ObservableObject {
//    @Published var value: String = ""
//    @Published var error: String? = nil
//    
//    private var cancellables = Set<AnyCancellable>()
//    private let validationRules: [AnyValidationRule<String>]
//    
//    /// Initializes the ValidatedField with an array of validation rules.
//    /// - Parameter validationRules: The validation rules to apply.
//    init(validationRules: [AnyValidationRule<String>]) {
//        self.validationRules = validationRules
//        setupValidation()
//    }
//    
//    /// Sets up the validation by observing changes to the value.
//    private func setupValidation() {
//        $value
//            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
//            .removeDuplicates()
//            .map { [weak self] in self?.validate($0) }
//            .sink { [weak self] in self?.error = $0 }
//            .store(in: &cancellables)
//    }
//    
//    /// Validates the current value against all validation rules.
//    /// - Parameter value: The value to validate.
//    /// - Returns: An optional error message if validation fails.
//    private func validate(_ value: String) -> String? {
//        print("Validating value: \(value)")
//        guard !value.isEmpty else {
//            return nil
//        }
//        for rule in validationRules {
//            if let error = rule.validate(value) {
//                return error
//            }
//        }
//        return nil
//    }
//}
//
///// A view modifier that attaches validation to a TextField.
//struct ValidatedFieldModifier: ViewModifier {
//    @ObservedObject var validatedField: ValidatedField
//    let placeholder: String
//    
//    func body(content: Content) -> some View {
//        VStack(alignment: .leading, spacing: 5) {
//            content
//                .padding()
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(validatedField.error == nil ? Color.gray : Color.red, lineWidth: 1)
//                )
//            
//            if let error = validatedField.error {
//                Text(error)
//                    .foregroundColor(.red)
//                    .font(.caption)
//            }
//        }
//    }
//}
//
///// An extension to easily apply the ValidatedFieldModifier.
//extension View {
//    func validatedField(validatedField: ValidatedField, placeholder: String) -> some View {
//        self.modifier(ValidatedFieldModifier(validatedField: validatedField, placeholder: placeholder))
//    }
//}
//









/*--- BASIC VALIDATION */

struct Validation {
    
    // Checks if the value is a string
//    static func isString(_ value: Any, errorVar: inout String?) throws {
//        guard value is String else {
//            throw BackstoryError(message: "The value must be a string.")
//        }
//    }
    
    // Checks if the string is not empty (required) and updates the error variable if validation fails
    static func isRequired(_ value: String, errorVar: inout String?) throws {
        print("Validating Required: \(value)")
        guard !value.isEmpty else {
            errorVar = "This field is required."
            throw BackstoryError(message: "An error occured while validating the form.  Please fix the error and try again.")
        }
        errorVar = nil
    }
    
    // Checks if the value is a string and updates the error variable if validation fails
    static func isString(_ value: Any, errorVar: inout String?) throws {
        guard value is String else {
            errorVar = "The value must be a string."
            throw BackstoryError(message: "An error occured while validating the form.  Please fix the error and try again.")
        }
        errorVar = nil
    }
    
    // Checks if the string length is greater than or equal to the min length
//    static func stringMin(_ value: String, min: Int, errorVar: inout String?) throws {
//        guard value.count >= min else {
//            throw BackstoryError(message: "The value must be at least \(min) characters long.")
//        }
//    }
    static func stringMin(_ value: String, min: Int, errorVar: inout String?) throws {
        guard value.count >= min else {
            errorVar = "The value must be at least \(min) characters long."
            throw BackstoryError(message: "An error occured while validating the form.  Please fix the error and try again.")
        }
        errorVar = nil
    }
    
    // Checks if the string length is less than or equal to the max length
//    static func stringMax(_ value: String, max: Int, errorVar: inout String?) throws {
//        guard value.count <= max else {
//            throw BackstoryError(message: "The value must be at most \(max) characters long.")
//        }
//    }
    static func stringMax(_ value: String, max: Int, errorVar: inout String?) throws {
        guard value.count <= max else {
            errorVar = "The value must be at most \(max) characters long."
            throw BackstoryError(message: "An error occured while validating the form.  Please fix the error and try again.")
        }
        errorVar = nil
    }
    
    // Checks if the string is not empty (required)
//    static func isRequired(_ value: String, errorVar: inout String?) throws {
//        guard !value.isEmpty else {
//            throw BackstoryError(message: "This field is required.")
//        }
//    }
}

//enum ValidationError: Error, LocalizedError {
//    case invalidType
//    case tooShort(min: Int)
//    case tooLong(max: Int)
//    case required
//    
//    var errorDescription: String? {
//        switch self {
//        case .invalidType:
//            return "The value must be a string."
//        case .tooShort(let min):
//            return "The value must be at least \(min) characters long."
//        case .tooLong(let max):
//            return "The value must be at most \(max) characters long."
//        case .required:
//            return "This field is required."
//        }
//    }
//}
