//
//  ContentView.swift
//  Backstory
//
//  Created by Candace Camarillo on 12/16/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                    SplashScreen(showSplash: $showSplash)
                } else {
                    PrivacyPolicyView()
                }
        }
        .padding()
    }
}

struct SplashScreen: View {
    @Binding var showSplash: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("Backstory")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Copyright 2024 Magnolia Software LLC.  All Rights Reserved.  Welcome to the future of mental health insight.  Tell your story.")
                .padding()
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    showSplash = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
        }
        .padding()
        .onAppear {
            // Start a timer to automatically dismiss the splash screen after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                showSplash = false
            }
        }
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Privacy Policy")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    // Action for dismiss button
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
