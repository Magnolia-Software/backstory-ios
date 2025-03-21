//
//  Buttons.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/20/25.
//

import SwiftUI

struct ActionButton: View {
    
    var title: String
    var action: () -> Void
    var alt: Bool = false
    var position: String = "leading"
    
    private var alignment: Alignment {
        switch position {
        case "leading":
            return .leading
        case "center":
            return .center
        case "trailing":
            return .trailing
        default:
            return .leading
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .textCase(.uppercase)
                .kerning(1.1)
                .foregroundColor(Stylesheet.Colors.background)
                .padding(.vertical, 15)
                .padding(.horizontal, 40)
                .background(Stylesheet.Colors.action)
                .cornerRadius(30)
                .frame(maxWidth: .infinity, alignment: alignment)
                .font(Stylesheet.Fonts.button)
                
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: alignment)
    }
}

struct ActionButtonAlt: View {
    
    var title: String
    var action: () -> Void
    var alt: Bool = false
    var position: String = "leading"
    
    private var alignment: Alignment {
        switch position {
        case "leading":
            return .leading
        case "center":
            return .center
        case "trailing":
            return .trailing
        default:
            return .leading
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .textCase(.uppercase)
                .kerning(1.1)
                .foregroundColor(Stylesheet.Colors.background)
                .padding(.vertical, 15)
                .padding(.horizontal, 40)
                .background(Stylesheet.Colors.action2)
                .cornerRadius(30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Stylesheet.Fonts.button)
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
//        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, alignment: alignment)
    }
}

struct CloseButton: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .foregroundColor(Stylesheet.Colors.action)
//                .padding()
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
}

