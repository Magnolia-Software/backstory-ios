//
//  NotSafe.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/14/25.
//

import SwiftUI
import os
import CoreLocation
import Speech

struct NotSafe: View {
    @EnvironmentObject var router: Router
    @StateObject private var locationManager = LocationManager()
    @EnvironmentObject var toastManager: ToastManager
    
    let logger = Logger(subsystem: "io.pyramidata.backstory", category: "networking")
    
    var body: some View {
        Heading1NoTabsText(text: "Safety", iconName: "exclamationmark.triangle.fill")
        VStack {
            VStack {
                Heading2Text(text: "Please contact a crisis service near you.")
                BodyText(text: "The National Suicide Prevention Hotline is available 24 hours. ")
                
                ActionButton(title: "Call 988", action: {
                    call988()
                })
                
                BodyText(text: "If you are in immediate danger, please call emergency services.")
                
                ActionButton(title: "Call 911", action: {
                    call911()
                })
                
                Heading3Text(text: "Your Current Location")
                    
                if let location = locationManager.location {
                    ScrollView1 {
                        VStack {
                            Text("Latitude: \(location.coordinate.latitude)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Longitude: \(location.coordinate.longitude)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    ActionButton(title: "Copy Location", action: {
                        CopyLocation()
                    })
                }
                Spacer()
                HStack {
                    Spacer()
                    CloseButton(action: {
                        //router.navigate(to: .safety)
                        router.navigate(to: .privacy)
                    })
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
        }
        .background(Stylesheet.Colors.background)
        
    }
    
    private func call988() {
        let phoneNumber = "tel://988"
        if let url = URL(string: phoneNumber) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Cannot make calls on this device")
            }
        }
    }
    
    private func call911() {
        let phoneNumber = "tel://911"
        if let url = URL(string: phoneNumber) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Cannot make calls on this device")
            }
        }
    }
    
    private func CopyLocation() {
        let location = locationManager.location
        let latitude = location?.coordinate.latitude ?? 0.0
        let longitude = location?.coordinate.longitude ?? 0.0
        let locationString = "Latitude: \(latitude), Longitude: \(longitude)"
        // save to clipboard
        UIPasteboard.general.string = locationString
        toastManager.showToast(message: "Copied Location to Clipboard")
    }

}
