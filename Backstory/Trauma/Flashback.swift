
//
//  Flashback

//  Backstory
//
//  Created by Candace Camarillo on 3/5/25.
//
//

import Foundation
import CoreData
import Combine

@objc(Flashback)
public class Flashback: NSManagedObject {
    // Custom logic (if any) goes here
}

extension Flashback {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flashback> {
        return NSFetchRequest<Flashback>(entityName: "Flashback")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var cause: String?
    @NSManaged public var date_unix: Int32
    @NSManaged public var discussed_with_friend: Bool
    @NSManaged public var discussed_in_therapy: Bool
    @NSManaged public var discussed_in_group: Bool
    @NSManaged public var spike_duration_seconds: Int16
    @NSManaged public var total_duration_seconds: Int16
    @NSManaged public var triggers: Trigger?
    
}

extension Flashback: Identifiable {
    // This extension makes the Flashback class conform to the Identifiable protocol.
}

class FlashbackManager {
    static let shared = FlashbackManager()
    
    private init() {}
    
    func createFlashback(
        name: String,
        desc: String? = "",
        cause: String? = "",
        date_unix: Int32? = Int32(Date().timeIntervalSince1970),
        discussed_with_friend: Bool? = false,
        discussed_in_therapy: Bool? = false,
        discussed_in_group: Bool? = false,
        spike_duration_seconds: Int16? = 0,
        total_duration_seconds: Int16? = 0,
        triggers: Trigger? = nil
    ) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let flashback = Flashback(context: context)
        flashback.name = name
        flashback.desc = desc
        flashback.cause = cause
        flashback.date_unix = date_unix ?? Int32(Date().timeIntervalSince1970)
        flashback.discussed_with_friend = discussed_with_friend ?? false
        flashback.discussed_in_therapy = discussed_in_therapy ?? false
        flashback.discussed_in_group = discussed_in_group ?? false
        flashback.spike_duration_seconds = spike_duration_seconds ?? 0
        flashback.total_duration_seconds = total_duration_seconds ?? 0
        flashback.triggers = triggers
        saveContext()
    }

    func fetchFlashbacks(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Flashback] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Flashback> = Flashback.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch flashbacks: \(error)")
            return []
        }
    }

    func deleteFlashback(_ flashback: Flashback) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        context.delete(flashback)
        saveContext()
    }

    private func saveContext() {
        CoreDataStack.shared.saveContext()
    }
}

//class FlashbackViewModel: ObservableObject {
//    @Published var flashbackName: ValidatedField
//    @Published var flashbackDescription: ValidatedField
//    @Published var canSubmit: Bool = false
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        // Define validation rules for flashback name.
//        let flashbackNameRules: [AnyValidationRule<String>] = [
//            AnyValidationRule(EmptyValidationRule(errorMessage: "Flashback name cannot be empty.")),
//            AnyValidationRule(EmailValidationRule(errorMessage: "Please enter a valid flashback name."))
//        ]
//        
//        // Define validation rules for flashback description.
//        let flashbackDescriptionRules: [AnyValidationRule<String>] = [
//            AnyValidationRule(EmptyValidationRule(errorMessage: "Flashback description cannot be empty.")),
//            AnyValidationRule(SpecialCharacterValidationRule(errorMessage: "Flashback description must contain at least one special character."))
//        ]
//        
//        // Initialize ValidatedFields with respective rules.
//        self.flashbackName = ValidatedField(validationRules: flashbackNameRules)
//        self.flashbackDescription = ValidatedField(validationRules: flashbackDescriptionRules)
//        
//        setupSubmitValidation()
//    }
//    
//    /// Sets up the logic to determine if the form can be submitted.
//    private func setupSubmitValidation() {
//        Publishers.CombineLatest(flashbackName.$error, flashbackDescription.$error)
//            .map { flashbackNameError, flashbackDescriptionError in
//                return flashbackNameError == nil && flashbackDescriptionError == nil && !self.flashbackName.value.isEmpty && !self.flashbackDescription.value.isEmpty
//            }
//            .assign(to: \.canSubmit, on: self)
//            .store(in: &cancellables)
//    }
//}
