
//
//  Statement

//  Backstory
//
//  Created by Candace Camarillo on 3/6/25.
//
//

import Foundation
import CoreData

@objc(Statement)
public class Statement: NSManagedObject {
    // Custom logic (if any) goes here
}

extension Statement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Statement> {
        return NSFetchRequest<Statement>(entityName: "Statement")
    }

    @NSManaged public var text: String?
    @NSManaged public var is_processed: Bool
    @NSManaged public var date_unix: Int32
}

extension Statement: Identifiable {
    // This extension makes the Statment class conform to the Identifiable protocol.
}

class StatementManager {
    static let shared = StatementManager()
    
    private init() {}
    
    func createStatement(
        text: String,
        is_processed: Bool,
        date_unix: Int32? = Int32(Date().timeIntervalSince1970)
    ) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let statement = Statement(context: context)
        statement.text = text
        statement.is_processed = false
        statement.date_unix = date_unix ?? Int32(Date().timeIntervalSince1970)
        saveContext()
    }

    func fetchStatements(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Statement] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Statement> = Statement.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch statements: \(error)")
            return []
        }
    }
    
    func fetchUnprocessedStatements() -> [Statement] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Statement> = Statement.fetchRequest()
        
        // Predicate to fetch unprocessed statements
        let predicate = NSPredicate(format: "is_processed == %@", NSNumber(value: false))
        fetchRequest.predicate = predicate
        
        // Sort descriptors to sort by date_unix in descending order
        let sortDescriptor = NSSortDescriptor(key: "date_unix", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Limit the fetch to a maximum of 5 entries
        fetchRequest.fetchLimit = 5

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch unprocessed statements: \(error)")
            return []
        }
    }

    func deleteStatement(_ statement: Statement) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        context.delete(statement)
        saveContext()
    }

    private func saveContext() {
        CoreDataStack.shared.saveContext()
    }
    
}

