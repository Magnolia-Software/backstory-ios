//
//  ToggleStyles.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/20/25.
//

import SwiftUI

struct BackstoryToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 51, height: 31)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
