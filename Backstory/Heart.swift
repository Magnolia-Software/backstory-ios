//
//  Heart.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/18/25.
//

import SwiftUI
import Speech
import CoreData
import UIKit

/** Our heart happens to be round :-) */
struct Heart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.addArc(center: center, radius: radius, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
        return path
    }
    
}

struct ResetHeart: View {
    var body: some View {
        Heart()
            .frame(width: 200, height: 200)
            .foregroundColor(.red)
            .shadow(color: .pink, radius: 10)
            .frame(width: 300, height: 300)
           
    }
}

struct PulsingHeart: View {
    var emotionColor: Color
    var pulseDuration: Double
    @State private var heartPulse: CGFloat = 2.0
    
    var body: some View {
        Heart()
            .frame(width: 100, height: 100)
            .foregroundColor(emotionColor)
            .scaleEffect(heartPulse)
            .animation(.easeInOut(duration: 2.0), value: emotionColor)
            .onAppear{
                withAnimation(.easeInOut(duration: pulseDuration).repeatForever(autoreverses: true)) {
                    // determines the size of the heart
                    heartPulse = 1.3 * heartPulse
                }
            }
//            
            
    }
    
    private func startPulsing(pulseDuration: Double) {
        withAnimation(.easeInOut(duration: pulseDuration).repeatForever(autoreverses: true)) {
            heartPulse = 1.1 * pulseDuration
        }
    }

}

