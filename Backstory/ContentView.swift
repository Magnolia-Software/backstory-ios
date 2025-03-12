

import SwiftUI
import os
import CoreLocation
import Speech

enum Route {
    case splash
    case privacy
    case safety
    case notsafe
    case listen
}

class Router: ObservableObject {
    @Published var currentRoute: Route = .splash
    
    init() {
        // Check the environment variable DEV_MODE
        if let devMode = ProcessInfo.processInfo.environment["DEV_MODE"], devMode == "1" {
            currentRoute = .listen
        } else {
            currentRoute = .splash
        }
    }

    func navigate(to route: Route) {
        currentRoute = route
    }
}

struct ContentView: View {

    @StateObject private var router = Router()
    @EnvironmentObject var toastManager: ToastManager
    
    let logger = Logger(subsystem: "io.pyramidata.backstory", category: "networking")
    
    
    var body: some View {
        ZStack {
            
            switch router.currentRoute {
                case .splash:
                    Splash().environmentObject(router)
                case .privacy:
                    Privacy().environmentObject(router)
                case .safety:
                    Safety().environmentObject(router)
                case .notsafe:
                    NotSafe().environmentObject(router)
                case .listen:
                    Listen(router: router).environmentObject(router)
            }
            VStack {
                Spacer()
                if toastManager.isShowing {
                    Toast(message: toastManager.message, onClose: {
                        toastManager.hideToast()
                    })
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.5), value: toastManager.isShowing)
                }
            }
        }
        .padding()
    }
}

struct Splash: View {
    
    @EnvironmentObject var router: Router
    
    let logger = Logger(subsystem: "io.pyramidata.backstory", category: "networking")
    var body: some View {
        VStack {
            Spacer()
            Text("Backstory")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Copyright 2025 Magnolia Software LLC.  All Rights Reserved.  Welcome to the future of mental health insight.  Tell your story.")
                .padding()
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    router.navigate(to: .privacy)
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
                guard let devMode = ProcessInfo.processInfo.environment["DEV_MODE"] else {
                    print("DEV_MODE key is missing")
                    return
                }
                if devMode != "1" {
                    if router.currentRoute == .splash {
                        router.navigate(to: .privacy)
                    }
                }
            }
        }
    }
}

struct Privacy: View {
    @EnvironmentObject var router: Router
    
    let logger = Logger(subsystem: "io.pyramidata.backstory", category: "networking")
    
    var body: some View {
        VStack {
            Spacer()

            Text("Privacy Policy")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("We have made every effort to ensure you story remains private.  We'll cover the details later.  Since this is a beta product, I guarantee no privacy at this point.")
                .padding()
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    router.navigate(to: .safety)
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
        }
        .padding()
        .onAppear {
            // logger.info("hi")
        }
    }
}

struct NotSafe: View {
    @EnvironmentObject var router: Router
    @StateObject private var locationManager = LocationManager()
    
    let logger = Logger(subsystem: "io.pyramidata.backstory", category: "networking")
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Please contact a crisis service near you.")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                call988()
            }) {
                Text("Call National Crisis Hotline (988)")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Spacer()
            Button(action: {
                call911()
            }) {
                Text("Call Local Emergency Services (911)")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Spacer()
            if let location = locationManager.location {
                Text("Your current location.")
                Text("Latitude: \(location.coordinate.latitude)")
                Text("Longitude: \(location.coordinate.longitude)")
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    router.navigate(to: .safety)
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
            Spacer()
        }
        .padding()
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
}

struct Safety: View {
    
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            Spacer()
            Text("Safety")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Your safety is our top piority.  This application is not intended to help in case you are not safe.  Call emergency services or your local crisis line for help if you are feeling unsafe.")
                .padding()
            Button(action: {
                router.currentRoute = .listen
            }) {
                Text("I am safe.  CONTINUE.")
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
            }
            Button(action: {
                router.navigate(to: .notsafe)
            }) {
                Text("I am NOT SAFE.")
                    .fontWeight(.bold)
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    // change route
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

struct Content: View {
    @StateObject private var router = Router()
    
    var body: some View {
        ContentView()
        Listen(router: router)
    }
}
