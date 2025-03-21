//
//  Launch.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/14/25.
//


import SwiftUI
import os
import CoreLocation
import Speech

struct LaunchScreenView: View {
    @EnvironmentObject var router: Router
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            FullScreenBackground()
            VStack {
                Spacer()
                Text("Backstory")
                    .fontWeight(.bold)
                    .font(Stylesheet.Fonts.heading1)
                    .foregroundColor(Stylesheet.Colors.heading2)
                    .padding()
                Text("A Trauma-Informed Introspection Tool")
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    )
                    .font(Stylesheet.Fonts.heading3)
                    .padding()
                    .foregroundColor(Stylesheet.Colors.heading1)
                    .multilineTextAlignment(.center)
                Text("For anyone with a story to tell.")
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    )
                    .font(Stylesheet.Fonts.body)
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundColor(Stylesheet.Colors.body)
                
                Text("Copyright 2025, Magnolia Software LLC.")
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    )
                    .font(Stylesheet.Fonts.body)
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundColor(Stylesheet.Colors.body)
                Spacer()
            }
            .padding()
        }
        .onAppear {
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               // get user settings
               let settings = SettingManager.shared.fetchSettings()
               if (settings.count != 0) {
                   if (settings[0].date_user_accepted_agreement != 0) {
                       if (settings[0].is_safety_check_hidden) {
                           router.navigate(to: .diagnostic)
                       } else {
                           router.navigate(to: .safety)
                       }
                   } else {
                       router.navigate(to: .privacy)
                   }
               } else {
                   router.navigate(to: .privacy)
               }
               
           }
       }
    }
}
