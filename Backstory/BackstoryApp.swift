//
//  Backstory
//
//  Created by Candace Camarillo on 12/16/2024.  In honor of George Floyd.
//

import SwiftUI


@main
struct Backstory: App {
    @StateObject private var toastManager = ToastManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .edgesIgnoringSafeArea(.all)
                .environmentObject(toastManager)
        }
    }
}
