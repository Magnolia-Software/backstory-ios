//
//  BackstoryApp.swift
//  Backstory
//
//  Created by Candace Camarillo on 12/16/24.
//

import SwiftUI

struct BackstoryView: View {
    var body: some View {
        VStack {
            Text("Hello, SwiftUI!")
                .font(.largeTitle)
                .padding()
            Button(action: {
                print("Button tapped!")
            }) {
                Text("Tap me")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

@main
struct Backstory: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
