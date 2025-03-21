//
//  Backstory
//
//  Created by Candace Camarillo on 12/16/2024.  In honor of George Floyd.

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

