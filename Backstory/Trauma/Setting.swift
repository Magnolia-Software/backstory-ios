//
//  Setting.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/14/25.
//

import Foundation
import CoreData

@objc(Setting)
public class Setting: NSManagedObject {
    // Custom logic (if any) goes here
}

extension Setting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Setting> {
        return NSFetchRequest<Setting>(entityName: "Setting")
    }

    @NSManaged public var date_user_accepted_agreement: Int32
    @NSManaged public var is_safety_check_hidden: Bool
}

extension Setting: Identifiable {
    // This extension makes the Setting class conform to the Identifiable protocol.
}

class SettingManager {
    static let shared = SettingManager()
    
    public init() {}
    
    func handleAiSettings(settings: [String]) {
    }
    
    func acceptUserAgreement() {
        // look for existing settings
        let existingSettings = fetchSettings()
        if !existingSettings.isEmpty {
            // if settings exist, update the first one
            let setting = existingSettings[0]
            setting.date_user_accepted_agreement = Int32(Date().timeIntervalSince1970)
            saveContext()
            return
        } else {
            // if no settings exist, create a new one
            print("Creating new setting")
            let context = CoreDataStack.shared.persistentContainer.viewContext
            let setting = Setting(context: context)
            setting.date_user_accepted_agreement = Int32(Date().timeIntervalSince1970)
            saveContext()
        }
    }
    
    func fetchSafetyCheckSetting() -> Bool {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Setting> = Setting.fetchRequest()
        
        do {
            let settings = try context.fetch(fetchRequest)
            if let setting = settings.first {
                return setting.is_safety_check_hidden
            }
        } catch {
            print("Failed to fetch settings: \(error)")
        }
        
        return false
    }
    
    func hideSafetyCheck() {
        let settings = fetchSettings()
        if !settings.isEmpty {
            let setting = settings[0]
            print("setting 1 a")
            print(setting)
            print(setting.is_safety_check_hidden)
            setting.is_safety_check_hidden = true
            saveContext()
        } else {
            let context = CoreDataStack.shared.persistentContainer.viewContext
            let setting = Setting(context: context)
            setting.is_safety_check_hidden = true
            saveContext()
        }
    }
    
    func showSafetyCheck() {
        let settings = fetchSettings()
        if !settings.isEmpty {
            let setting = settings[0]
            print("setting 2 a")
            print(setting)
            setting.is_safety_check_hidden = false
            saveContext()
        } else {
            print("setting 3")
            let context = CoreDataStack.shared.persistentContainer.viewContext
            let setting = Setting(context: context)
            setting.is_safety_check_hidden = false
            saveContext()
        }
    }
    
    func clearUserSettings() {
        let settings = fetchSettings()
        if !settings.isEmpty {
            for setting in settings {
                deleteSetting(setting)
            }
        }
    }

    func fetchSettings(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Setting] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Setting> = Setting.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        do {
            print("returning")
            print(try context.fetch(fetchRequest))
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch settings: \(error)")
            return []
        }
    }

    func deleteSetting(_ setting: Setting) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        context.delete(setting)
        saveContext()
    }

    private func saveContext() {
        CoreDataStack.shared.saveContext()
    }
}
