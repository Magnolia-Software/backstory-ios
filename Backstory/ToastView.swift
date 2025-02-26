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
        HStack(alignment: .top) {
            Text(message)
                .foregroundColor(Color.red)
                .padding()
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color.red)
                    .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.bottom, 20)
        .padding()
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}
