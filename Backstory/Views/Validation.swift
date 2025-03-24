//
//  Validation.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/24/25.
//

import Foundation

struct Validation {
    
    // Checks if the value is a string
    static func isString(_ value: Any) throws {
        guard value is String else {
            throw ValidationError.invalidType
        }
    }
    
    // Checks if the string length is greater than or equal to the min length
    static func stringMin(_ value: String, min: Int) throws {
        guard value.count >= min else {
            throw ValidationError.tooShort(min: min)
        }
    }
    
    // Checks if the string length is less than or equal to the max length
    static func stringMax(_ value: String, max: Int) throws {
        guard value.count <= max else {
            throw ValidationError.tooLong(max: max)
        }
    }
    
    // Checks if the string is not empty (required)
    static func isRequired(_ value: String) throws {
        guard !value.isEmpty else {
            throw ValidationError.required
        }
    }
}

enum ValidationError: Error, LocalizedError {
    case invalidType
    case tooShort(min: Int)
    case tooLong(max: Int)
    case required
    
    var errorDescription: String? {
        switch self {
        case .invalidType:
            return "The value must be a string."
        case .tooShort(let min):
            return "The value must be at least \(min) characters long."
        case .tooLong(let max):
            return "The value must be at most \(max) characters long."
        case .required:
            return "This field is required."
        }
    }
}
