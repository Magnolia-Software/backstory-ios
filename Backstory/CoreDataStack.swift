import Combine
import CoreData

//
//  CoreDataStack.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/5/25.
//

// Define an observable class to encapsulate all Core Data-related functionality.
class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Pass the data model filename to the container’s initializer.
        let container = NSPersistentContainer(name: "Trauma")
        
        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { _, error in
            if let error {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    // Provide a context to interact with the persistent container.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Save any changes in the context to the persistent store.
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private init() { }
}
