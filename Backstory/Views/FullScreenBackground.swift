//
//  FullScreenBackground.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/13/25.
//

import SwiftUI

struct FullScreenBackground: View {
    var body: some View {
        
        Text("")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(width: UIScreen.main.bounds.width)
            .background(Stylesheet.Colors.background)
            .foregroundColor(Color.white)
            .font(.largeTitle)
    }
}
