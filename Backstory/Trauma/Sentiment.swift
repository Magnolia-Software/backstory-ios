//
//  Sentiment.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/8/25.
//

import Foundation
import CoreData

@objc(Sentiment)
public class Sentiment: NSManagedObject {
    // Custom logic (if any) goes here
}

extension Sentiment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sentiment> {
        return NSFetchRequest<Sentiment>(entityName: "Sentiment")
    }

    @NSManaged public var name: String?
    @NSManaged public var date_unix: Int32
}

extension Sentiment: Identifiable {
    // This extension makes the Statment class conform to the Identifiable protocol.
}

class SentimentManager {
    static let shared = SentimentManager()
    
    private init() {}
    
    func createSentiment(
        name: String,
        date_unix: Int32? = Int32(Date().timeIntervalSince1970)
    ) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let sentiment = Sentiment(context: context)
        sentiment.name = name
        sentiment.date_unix = date_unix ?? Int32(Date().timeIntervalSince1970)
        saveContext()
    }

    func fetchSentiments(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Sentiment] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Sentiment> = Sentiment.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch sentiments: \(error)")
            return []
        }
    }
    
    func deleteSentiment(_ sentiment: Sentiment) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        context.delete(sentiment)
        saveContext()
    }

    private func saveContext() {
        CoreDataStack.shared.saveContext()
    }
    
}

