//
//  Safety.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/14/25.
//

import SwiftUI
import os
import CoreLocation
import Speech


struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(configuration.isOn ? .blue : .gray)
                configuration.label
            }
        }
    }
}


struct Safety: View {
    
    @EnvironmentObject var router: Router
    @State private var hide: Bool = false
    @State private var isChecked: Bool = false
    
    
    
    
    
    var body: some View {
        
        Heading1NoTabsText(text: "Safety", iconName: "exclamationmark.triangle.fill")
    
        VStack {
            VStack {
                Heading2Text(text: "Are you safe?")
                        
                BodyText(text: "Your safety is our top priority.  This application is not intended to help in case you are not safe.  Call emergency services or your local crisis line for help if you are feeling unsafe.")
                Toggle(isOn: $isChecked) {
                    BodyText(text: "Hide this step from now on.")
                }
                .padding(.bottom, 20)
                .toggleStyle(BackstoryToggleStyle(onColor: Stylesheet.Colors.heading1, offColor: Stylesheet.Colors.altBackground2))
                .onChange(of: isChecked) { newValue in
                    if newValue {
                        SettingManager.shared.hideSafetyCheck()
                    } else {
                        print("show safety check!")
                        SettingManager.shared.showSafetyCheck()
                    }
                }
                VStack {
                    ActionButton(title: "I AM SAFE", action: {
                        router.currentRoute = .diagnostic
                    })
                    .padding(.bottom, 20)
                    ActionButtonAlt(title: "I AM NOT SAFE", action: {
                        router.navigate(to: .notsafe)
                    })
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .background(Stylesheet.Colors.background)
    }
    
    
        
        
//
//
//
//
//        HStack {
//            Image(systemName: "exclamationmark.triangle.fill")
//                .font(.title)
//                .foregroundColor(Stylesheet.Colors.heading1)
//            Text("Are you Safe?")
//                .font(Stylesheet.Fonts.heading2)
//                .foregroundColor(Stylesheet.Colors.heading1)
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
////        ZStack {
////            FullScreenBackground()
//        VStack {
//            VStack {
//                Spacer()
//                VStack {
//                    Text("Your safety is our top piority.  This application is not intended to help in case you are not safe.  Call emergency services or your local crisis line for help if you are feeling unsafe.")
//                        .font(Stylesheet.Fonts.body)
//                        .padding()
//                    Toggle(isOn: $isChecked) {
//                        Text("Hide this step from now on.")
//                    }
//                    .toggleStyle(CheckboxToggleStyle())
//                    //.padding()
//                    .onChange(of: isChecked) { newValue in
//                        if newValue {
//                            SettingManager.shared.hideSafetyCheck()
//                        } else {
//                            print("show safety check!")
//                            SettingManager.shared.showSafetyCheck()
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                //                Text("Are you safe?")
//                //                    .font(Stylesheet.Fonts.heading2)
//                //                    .fontWeight(.bold)
//                //                    .foregroundColor(Stylesheet.Colors.heading2)
//
////                Spacer()
//                Button(action: {
//                    router.currentRoute = .diagnostic
//                }) {
//                    Text("I am safe.  CONTINUE.")
//                        .foregroundColor(Color.black)
//                        .padding()
//                        .background(Stylesheet.Colors.action)
//                        .cornerRadius(8)
//                        .padding(.bottom, 50)
//                        .fontWeight(.bold)
//                }
//
//                Button(action: {
//                    router.navigate(to: .notsafe)
//                }) {
//                    Text("I am NOT SAFE.")
//                        .foregroundColor(Color.white)
//                        .padding()
//                        .background(Stylesheet.Colors.error)
//                        .cornerRadius(8)
//
//                        .fontWeight(.bold)
//                }
//                //Spacer()
//            }
//            .frame(maxWidth: .infinity)
//
//        }
//        .background(Stylesheet.Colors.background)
        //.padding()
//        }
        
    //}
}
