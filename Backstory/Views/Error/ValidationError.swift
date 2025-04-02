//
//  ValidationError.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/26/25.
//

import Foundation


struct ValidationError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    var localizedDescription: String {
        return message
    }
}
