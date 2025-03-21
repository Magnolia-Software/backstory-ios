//
//  Diagnostic.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/14/25.
//

import SwiftUI

struct Diagnostic: View {
    @EnvironmentObject var diagnosticRouter: Router
    @ObservedObject var listenViewModel: Listen

    var body: some View {
        TabView {
            Tab("Listen", systemImage: "waveform") {
                ListenView(listenViewModel: listenViewModel)
                    .onDisappear {
                        listenViewModel.stopListening()
                    }
            }
            Tab("Explore", systemImage: "magnifyingglass") {
                Text("Explore View")
            }
            Tab("Settings", systemImage: "gear") {
                Settings()
            }
        }
        .accentColor(Stylesheet.Colors.heading1) // Default accent color for the TabView
        .background(Stylesheet.Colors.error)
    }
}
