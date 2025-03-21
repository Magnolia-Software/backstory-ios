//
//  ToastView.swift
//  Backstory
//
//  Created by Candace Camarillo on 2/25/25.
//

import SwiftUI

struct Toast: View {
    var message: String
    var onClose: () -> Void
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                Text(message)
                    .foregroundColor(Color.white)
                    //.background(Stylesheet.Colors.error)
                    //.padding()
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.white)
                        
                }
            }
            .padding()
            .background(Stylesheet.Colors.error)
            .cornerRadius(10)
            .padding(.bottom, 20)
            .shadow(color: Color.black.opacity(0.6), radius: 10, x: 5, y: 5)
        }
        .padding()
    }
}
