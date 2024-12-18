//
//  Backstory
//
//  Created by Candace Camarillo on 12/16/2024.  In honor of George Floyd.  May we be better.
//

import SwiftUI
import os

enum Route {
    case splash
    case privacy
    case safety
}

class Router: ObservableObject {
    @Published var currentRoute: Route = .splash
    
    func navigate(to route: Route) {
        currentRoute = route
    }
}

struct ContentView: View {

    @StateObject private var router = Router()
    
    let logger = Logger(subsystem: "com.example.yourapp", category: "networking")
    
    var body: some View {
        ZStack {
            
            switch router.currentRoute {
                case .splash:
                    Splash().environmentObject(router)
                case .privacy:
                    Privacy().environmentObject(router)
                case .safety:
                    Safety().environmentObject(router)
            }
        }
        .padding()
        .onAppear {
            
        }
    }
}

struct Splash: View {
    
    @EnvironmentObject var router: Router
    
    let logger = Logger(subsystem: "com.example.yourapp", category: "networking")
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
                // change route
            }
        }
    }
}

struct Privacy: View {
    @EnvironmentObject var router: Router
    
    let logger = Logger(subsystem: "com.example.yourapp", category: "networking")
    
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
                // open the experience
            }) {
                Text("I am safe.  CONTINUE.")
                    .fontWeight(.bold)
            }
            Button(action: {
                
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
