//
//  Validation.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/24/25.
//

import Foundation
import SwiftUI
import Combine


struct ValidationManager {
    static func validate(fields: [(value: String, errorVar: (inout String?) -> Void, rules: [(String, inout String?) throws -> Void])]) throws {
        var errorThrown = false
        
        for (value, setErrorVar, rules) in fields {
            var errorVar: String? = nil
            do {
                try Validation.runValidationRules(rules: rules, value: value, errorVar: &errorVar)
            } catch {
                errorThrown = true
            }
            setErrorVar(&errorVar)
        }
        
        if errorThrown {
            throw ValidationError("Please fix the errors in the form and try again.")
        }
    }
}

struct Validation {
    
    static func buildValidationRules(value: String, errorVar: inout String?, rules: [(String, inout String?) throws -> Void]) -> [(String, inout String?) throws -> Void] {
       return rules
   }
   
   static func runValidationRules(rules: [(String, inout String?) throws -> Void], value: String, errorVar: inout String?) throws {
       for rule in rules {
           try rule(value, &errorVar)
       }
   }
    
    /** EACH VALIDATION RULE HERE */
    
    static func isRequired(_ value: String, errorVar: inout String?) throws{
        guard !value.isEmpty else {
            errorVar = "This field is required."
            throw BackstoryError(message: "An error occured while validating the form.  Please fix the error and try again.")
        }
    }

    static func isString(_ value: Any, errorVar: inout String?) throws {
        guard value is String else {
            errorVar = "The value must be a string."
            throw BackstoryError(message: "An error occured while validating the form.  Please fix the error and try again.")
        }
    }

    static func stringMin(_ value: String, min: Int, errorVar: inout String?) throws {
        guard value.count >= min else {
            errorVar = "The value must be at least \(min) characters long."
            throw BackstoryError(message: "An error occured while validating the form.  Please fix the error and try again.")
        }
    }

    static func stringMax(_ value: String, max: Int, errorVar: inout String?) throws {
        guard value.count <= max else {
            errorVar = "The value must be at most \(max) characters long."
            throw BackstoryError(message: "An error occured while validating the form.  Please fix the error and try again.")
        }
    }

}
