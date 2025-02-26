//
//  ToastManager.swift
//  Backstory
//
//  Created by Candace Camarillo on 2/25/25.
//


import Combine
import Foundation
import SwiftUI

class ToastManager: ObservableObject {
    @Published var isShowing = false
    @Published var message = ""
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            self.message = message
            withAnimation {
                self.isShowing = true
            }
        }
    }
    func hideToast() {
        DispatchQueue.main.async {
            withAnimation {
                self.isShowing = false
            }
        }
    }
}
