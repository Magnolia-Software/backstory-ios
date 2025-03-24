

import SwiftUI
import os
import CoreLocation
import Speech

enum Route {
    case splash
    case privacy
    case safety
    case notsafe
    //case listen
    case diagnostic
}

class Router: ObservableObject {
    @Published var currentRoute: Route = .privacy
    
    init() {
        // Check the environment variable DEV_MODE
        if let devMode = ProcessInfo.processInfo.environment["DEV_MODE"], devMode == "1" {
            currentRoute = .diagnostic
        } else {
            // get settings
//            let settings = SettingManager.shared.fetchSettings()
//            if (settings.count != 0) {
//                if (settings[0].date_user_accepted_agreement == 0) {
//                    currentRoute = .splash
//                } else {
//                    currentRoute = .listen
//                }
//            } else {
//                currentRoute = .privacy
//            }
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
    @StateObject private var listenViewModel = Listen(router: Router())
    
    var body: some View {
        ZStack {
            VStack {
                switch router.currentRoute {
                    case .splash:
                        LaunchScreenView().environmentObject(router)
                    case .privacy:
                        Privacy().environmentObject(router)
                    case .safety:
                        Safety().environmentObject(router)
                    case .notsafe:
                        NotSafe().environmentObject(router)
                    case .diagnostic:
                        Diagnostic(listenViewModel: listenViewModel).environmentObject(router).environmentObject(toastManager)
                }
            }
            
            if toastManager.isShowing {
                VStack {
                    Toast(message: toastManager.message, onClose: {
                        toastManager.hideToast()
                    })
                    .transition(.move(edge: .top))
                    .padding(.top, 50)
                    Spacer()
                }
                .zIndex(1)
                .animation(.easeInOut(duration: 0.5), value: toastManager.isShowing)
            }
        }
        
    }
}
