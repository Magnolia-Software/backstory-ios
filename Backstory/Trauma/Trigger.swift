
//
//  Trigger

//  Backstory
//
//  Created by Candace Camarillo on 3/5/25.
//
//

import Foundation
import CoreData

@objc(Trigger)
public class Trigger: NSManagedObject {
    // Custom logic (if any) goes here
}

extension Trigger {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trigger> {
        return NSFetchRequest<Trigger>(entityName: "Trigger")
    }

    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var date_unix: Int32
//    @NSManaged public var flashbacks: Flashback?
}

extension Trigger: Identifiable {
    // This extension makes the Trigger class conform to the Identifiable protocol.
}

class TriggerManager {
    static let shared = TriggerManager()
    
    public init() {}
    
    func handleAiTriggers(triggers: [String]) {
//        print("HANDLE AI TRIGGERS")
//        print(triggers)
    }
    
    func createTrigger(
        name: String,
        notes: String? = "",
        date_unix: Int32? = Int32(Date().timeIntervalSince1970)
    ) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let trigger = Trigger(context: context)
        trigger.name = name
        trigger.notes = notes
        trigger.date_unix = date_unix ?? Int32(Date().timeIntervalSince1970)
        saveContext()
    }

    func fetchTriggers(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Trigger] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trigger> = Trigger.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch triggers: \(error)")
            return []
        }
    }

    func deleteTrigger(_ trigger: Trigger) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        context.delete(trigger)
        saveContext()
    }

    private func saveContext() {
        CoreDataStack.shared.saveContext()
    }
}


// HOW TO USE
// Create a new trigger
//        TriggerManager.shared.createTrigger(name: "Loud Noise 23", notes: "Triggered 2 by loud noises like fireworks.")
//
//        // Fetch all triggers
//        let triggers = TriggerManager.shared.fetchTriggers()
//        for trigger in triggers {
//            print("""
//                Trigger Name: \(trigger.name ?? "No Name")
//                Notes: \(trigger.notes ?? "No Notes")
//                Date: \(trigger.date_unix)
//                """)
//        }

//        // Assuming you want to delete the first trigger
//        if let firstTrigger = triggers.first {
//            TriggerManager.shared.deleteTrigger(firstTrigger)
//        }
//
//        // Fetch all triggers again to see the updated list
//        let updatedTriggers = TriggerManager.shared.fetchTriggers()
//        for trigger in updatedTriggers {
//            print("""
//                Updated Trigger Name: \(trigger.name ?? "No Name")
//                Updated Notes: \(trigger.notes ?? "No Notes")
//                Updated Date: \(trigger.date_unix)
//                """)
//        }
//
