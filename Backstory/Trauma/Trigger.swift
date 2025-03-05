
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
    
    private init() {}
    
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

