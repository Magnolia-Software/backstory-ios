
//
//  Emotion

//  Backstory
//
//  Created by Candace Camarillo on 3/7/25.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Emotion)
public class Emotion: NSManagedObject {
    // Custom logic (if any) goes here
}

extension Emotion {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Emotion> {
        return NSFetchRequest<Emotion>(entityName: "Emotion")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var date_unix: Int32
    
}

extension Emotion: Identifiable {
    // This extension makes the Flashback class conform to the Identifiable protocol.
}

class EmotionManager: NSObject {
    static let shared = EmotionManager()
    //    @Published var emotionName: String = ""
    //@Published var emotionColor: String = ""
    
    override init() {
        
    }
    
    func createEmotion(
        name: String,
        date_unix: Int32? = Int32(Date().timeIntervalSince1970)
    ) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let emotion = Emotion(context: context)
        emotion.name = name
        emotion.date_unix = date_unix ?? Int32(Date().timeIntervalSince1970)
        saveContext()
    }
    
    func fetchEmotions(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Emotion] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Emotion> = Emotion.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch emotions: \(error)")
            return []
        }
    }
    
    func deleteEmotion(_ emotion: Emotion) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        context.delete(emotion)
        saveContext()
    }
    
    private func saveContext() {
        CoreDataStack.shared.saveContext()
    }
    
    func handleAiEmotion(emotion: String) -> Emotion2 {
        let emotion = emotion.lowercased()
        let matchedEmotion = self.matchEmotion(phrase: emotion)
        
        if (matchedEmotion != nil) {
            self.createEmotion(
                name: matchedEmotion?.name ?? "",
                date_unix: Int32(Date().timeIntervalSince1970)
            )
            
            let emotionName = matchedEmotion?.name ?? ""
            let emotionColor = matchedEmotion?.color ?? ""
            return Emotion2(name: emotionName, color: emotionColor)
        }
        return Emotion2(name: "", color: "")
    }
    
    func matchEmotion(phrase: String) -> Emotion2? {
        let words = phrase.lowercased().split(separator: " ").map { String($0) }
        let emotionViewModel = EmotionViewModel()
        let emotions = emotionViewModel.getEmotionsJson()
        for emotion in emotions {
            if words.contains(emotion.name.lowercased()) {
                let emotion = Emotion2(name: emotion.name, color: emotion.color)
                return emotion
            }
        }
        return nil
    }
}


struct Emotion2: Codable, Identifiable {
    var id = UUID()
    let name: String
    let color: String
}

struct Emotion3: Codable {
    let name: String
    let color: String
}

struct EmotionWheel: Codable {
    let emotions: [Emotion2]
}

class EmotionViewModel: ObservableObject {
    @Published var emotionWheel: EmotionWheel?
    
    init() {
        loadEmotions()
    }
    
    public func getEmotionsJson() -> [Emotion3] {
        let json = """
        [
            {
                "name": "Joy",
                "color": "#FFFF00"
            },
            {
                "name": "Serenity",
                "color": "#FFFF99"
            },
            {
                "name": "Ecstasy",
                "color": "#FFD700"
            },
            {
                "name": "Cheerfulness",
                "color": "#FFFACD"
            },
            {
                "name": "Contentment",
                "color": "#FFF8DC"
            },
            {
                "name": "Happiness",
                "color": "#FFFACD"
            },
            {
                "name": "Trust",
                "color": "#00FF00"
            },
            {
                "name": "Acceptance",
                "color": "#99FF99"
            },
            {
                "name": "Admiration",
                "color": "#00CC00"
            },
            {
                "name": "Kindness",
                "color": "#98FB98"
            },
            {
                "name": "Friendliness",
                "color": "#90EE90"
            },
            {
                "name": "Loyalty",
                "color": "#32CD32"
            },
            {
                "name": "Fear",
                "color": "#0000FF"
            },
            {
                "name": "Apprehension",
                "color": "#9999FF"
            },
            {
                "name": "Terror",
                "color": "#0000CC"
            },
            {
                "name": "Nervousness",
                "color": "#1E90FF"
            },
            {
                "name": "Anxiety",
                "color": "#87CEEB"
            },
            {
                "name": "Worry",
                "color": "#4682B4"
            },
            {
                "name": "Sadness",
                "color": "#000080"
            },
            {
                "name": "Pensiveness",
                "color": "#666699"
            },
            {
                "name": "Grief",
                "color": "#000033"
            },
            {
                "name": "Sorrow",
                "color": "#708090"
            },
            {
                "name": "Despair",
                "color": "#2F4F4F"
            },
            {
                "name": "Melancholy",
                "color": "#778899"
            },
            {
                "name": "Disgust",
                "color": "#008000"
            },
            {
                "name": "Boredom",
                "color": "#66CC66"
            },
            {
                "name": "Loathing",
                "color": "#004400"
            },
            {
                "name": "Aversion",
                "color": "#556B2F"
            },
            {
                "name": "Distaste",
                "color": "#6B8E23"
            },
            {
                "name": "Revulsion",
                "color": "#8FBC8F"
            },
            {
                "name": "Anger",
                "color": "#FF0000"
            },
            {
                "name": "Annoyance",
                "color": "#FF6666"
            },
            {
                "name": "Rage",
                "color": "#CC0000"
            },
            {
                "name": "Irritation",
                "color": "#FF4500"
            },
            {
                "name": "Exasperation",
                "color": "#FF6347"
            },
            {
                "name": "Hostility",
                "color": "#B22222"
            },
            {
                "name": "Anticipation",
                "color": "#FFA500"
            },
            {
                "name": "Interest",
                "color": "#FFCC99"
            },
            {
                "name": "Vigilance",
                "color": "#FF6600"
            },
            {
                "name": "Eagerness",
                "color": "#FFA07A"
            },
            {
                "name": "Excitement",
                "color": "#FF8C00"
            },
            {
                "name": "Curiosity",
                "color": "#FFD700"
            },
            {
                "name": "Love",
                "color": "#FF69B4"
            },
            {
                "name": "Affection",
                "color": "#FFB6C1"
            },
            {
                "name": "Adoration",
                "color": "#FF1493"
            },
            {
                "name": "Passion",
                "color": "#FF69B4"
            },
            {
                "name": "Infatuation",
                "color": "#FF6EB4"
            },
            {
                "name": "Fondness",
                "color": "#FF82AB"
            },
            {
                "name": "Surprise",
                "color": "#FF00FF"
            },
            {
                "name": "Shock",
                "color": "#DA70D6"
            },
            {
                "name": "Astonishment",
                "color": "#EE82EE"
            },
            {
                "name": "Wonder",
                "color": "#DDA0DD"
            },
            {
                "name": "Disbelief",
                "color": "#BA55D3"
            },
            {
                "name": "Amazement",
                "color": "#CC00CC"
            },
            {
                "name": "Confidence",
                "color": "#00BFFF"
            },
            {
                "name": "Pride",
                "color": "#1E90FF"
            },
            {
                "name": "Self-assurance",
                "color": "#4682B4"
            },
            {
                "name": "Certainty",
                "color": "#87CEEB"
            },
            {
                "name": "Courage",
                "color": "#00CED1"
            },
            {
                "name": "Boldness",
                "color": "#5F9EA0"
            },
            {
                "name": "Contempt",
                "color": "#8B4513"
            },
            {
                "name": "Disdain",
                "color": "#A0522D"
            },
            {
                "name": "Scorn",
                "color": "#D2691E"
            },
            {
                "name": "Derision",
                "color": "#CD853F"
            },
            {
                "name": "Disrespect",
                "color": "#DEB887"
            },
            {
                "name": "Disregard",
                "color": "#F4A460"
            },
            {
                "name": "Remorse",
                "color": "#8A2BE2"
            },
            {
                "name": "Guilt",
                "color": "#9370DB"
            },
            {
                "name": "Regret",
                "color": "#BA55D3"
            },
            {
                "name": "Shame",
                "color": "#DDA0DD"
            },
            {
                "name": "Contrition",
                "color": "#DA70D6"
            },
            {
                "name": "Repentance",
                "color": "#EE82EE"
            },
            {
                "name": "Disappointment",
                "color": "#4682B4"
            },
            {
                "name": "Disillusionment",
                "color": "#5F9EA0"
            },
            {
                "name": "Letdown",
                "color": "#6495ED"
            },
            {
                "name": "Frustration",
                "color": "#1E90FF"
            },
            {
                "name": "Regret",
                "color": "#00BFFF"
            },
            {
                "name": "Resignation",
                "color": "#87CEFA"
            },
            {
                "name": "Hope",
                "color": "#87CEEB"
            },
            {
                "name": "Anticipation",
                "color": "#00BFFF"
            },
            {
                "name": "Optimism",
                "color": "#1E90FF"
            },
            {
                "name": "Expectation",
                "color": "#4682B4"
            },
            {
                "name": "Desire",
                "color": "#87CEFA"
            },
            {
                "name": "Aspiration",
                "color": "#00CED1"
            },
            {
                "name": "Gratitude",
                "color": "#FFD700"
            },
            {
                "name": "Thankfulness",
                "color": "#FFEA00"
            },
            {
                "name": "Appreciation",
                "color": "#FFD700"
            },
            {
                "name": "Recognition",
                "color": "#FFA500"
            },
            {
                "name": "Gratefulness",
                "color": "#FF8C00"
            },
            {
                "name": "Obligation",
                "color": "#FF4500"
            },
            {
                "name": "Jealousy",
                "color": "#32CD32"
            },
            {
                "name": "Envy",
                "color": "#00FF00"
            },
            {
                "name": "Covetousness",
                "color": "#7FFF00"
            },
            {
                "name": "Resentment",
                "color": "#ADFF2F"
            },
            {
                "name": "Insecurity",
                "color": "#98FB98"
            },
            {
                "name": "Suspicion",
                "color": "#00FA9A"
            },
            {
                "name": "Love",
                "color": "#FF69B4"
            },
            {
                "name": "Affection",
                "color": "#FFB6C1"
            },
            {
                "name": "Adoration",
                "color": "#FF1493"
            },
            {
                "name": "Passion",
                "color": "#FF69B4"
            },
            {
                "name": "Infatuation",
                "color": "#FF6EB4"
            },
            {
                "name": "Fondness",
                "color": "#FF82AB"
            }
        ]
        """
        let decoder = JSONDecoder()
        if let data = json.data(using: .utf8) {
            do {
                return try decoder.decode([Emotion3].self, from: data)
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        return []
    }
    
    func loadEmotions() {
        let json: [Emotion3] = self.getEmotionsJson()
    }
}
