////
////  Backstory
////
////  Created by Candace Camarillo on 12/16/2024.  In honor of George Floyd.
////
//
//import SwiftUI
//
//
//@main
//struct Backstory: App {
//    @StateObject private var toastManager = ToastManager()
//    @StateObject private var coreDataStack = CoreDataStack.shared
//    @State private var isLoading = true
//    
//    var body: some Scene {
//        WindowGroup {
////           if isLoading {
////               LaunchScreenView()
////                   .onAppear {
////                       // Simulate some loading work
////                       DispatchQueue.main.async {
////                           isLoading = false
////                       }
////                   }
////           } else {
//               ContentView()
//                   .edgesIgnoringSafeArea(.all)
//                   .environmentObject(toastManager)
//                   .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
////           }
//       }
//    }
//
//}
//
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
                    .foregroundColor(Stylesheet.Colors.error)
                    .padding()
                Text("A Trauma-Informed Introspection Tool")
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    )
                    .font(Stylesheet.Fonts.heading3)
                    .padding()
                    .foregroundColor(Stylesheet.Colors.heading)
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
                HStack {
//                    Spacer()
//                    
//                    Button(action: {
//                        //router.navigate(to: .privacy)
//                        print("got here")
//                    }) {
//                        Image(systemName: "xmark")
//                            .foregroundColor(.black)
//                            .padding()
//                    }
                }
            }
            .padding()
        }
        .onAppear {
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               router.navigate(to: .privacy)
           }
       }
    }
}


import SwiftUI
import os
import CoreLocation
import Speech

@main
struct Backstory: App {
    @StateObject private var toastManager = ToastManager()
    @StateObject private var coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .edgesIgnoringSafeArea(.all)
                .environmentObject(toastManager)
                .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
        }
    }
}

struct ContentView: View {
    
    @StateObject private var router = Router()
    @EnvironmentObject var toastManager: ToastManager
    
    var body: some View {
        ZStack {
            switch router.currentRoute {
                case .splash:
                    LaunchScreenView().environmentObject(router)
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
    }
}
