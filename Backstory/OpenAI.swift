//
//  OpenAI.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/5/25.
//

import Foundation

class OpenAI {
    
    static let shared = OpenAI()
    
    public init() {}
    
//    var apiKey: String {
//        return Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String ?? "NO_API_KEY_FOUND"
//    }
    
    struct OpenAIRequest: Codable {
        let emotion: String
        let triggers: [String]
        let flashbacks: [String]
    }
    
    struct OpenAIResponse: Codable {
        let emotion: Emotion2
        let triggers: [String]
        let flashbacks: [String]
    }
    
    public func processOpenAIResponse(_ response: String) -> OpenAIResponse {
        var cleanedResponse = response.replacingOccurrences(of: "```", with: "")
        cleanedResponse = cleanedResponse.replacingOccurrences(of: "json", with: "")
        print("CLEANED RESPONSE: \(cleanedResponse)")
        guard let jsonData = cleanedResponse.data(using: .utf8) else {
            print("Error: Cannot convert response string to data")
            return OpenAIResponse(emotion: Emotion2(name: "", color: ""), triggers: [], flashbacks: [])
        }

        do {
            let decodedResponse = try JSONDecoder().decode(OpenAIRequest.self, from: jsonData)
            let emotionManager = EmotionManager.shared
            let emotion = emotionManager.handleAiEmotion(emotion: decodedResponse.emotion)
            return OpenAIResponse(emotion: emotion, triggers: decodedResponse.triggers, flashbacks: decodedResponse.flashbacks)
        } catch {
            print("Error: Failed to decode JSON response - \(error.localizedDescription)")
        }
        
        return OpenAIResponse(emotion: Emotion2(name: "", color: ""), triggers: [], flashbacks: [])
    }
    
    func makeRequest(prompt: [String : [String]], completion: @escaping (String?) -> Void) {
        
        guard let urlString = ProcessInfo.processInfo.environment["OPENAI_API_URL"],
              let url = URL(string: urlString) else {
            print("API URL is missing or invalid")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String else {
//            print("API key is missing")
//            return
//        }
//
//        print("API Key: \(apiKey)")
//
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String else {
            print("API key is missing")
            return
        }

        print("API Key: \(apiKey)")

        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // iterate over the prompt to create a single paragraph.
        var promptText = ""
        for (role, messages) in prompt {
            for message in messages {
                promptText += "\(role): \(message)\n"
            }
        }
        
        let parameters: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                [
                    "role": "developer",
                    "content": """
                        You are an expert in data translation from natural language into JSON. You work with the trauma-informed models that are provided by the system role. Look at the system prompt for the model names. Convert the natural language paragraph prompt into JSON for output. Follow this general JSON format:
                            {
                                "model1": [
                                    {"uuid": "UUID1", "name": "A name for the model entry", "models2": ["UUID2"]}
                                ], 
                                "model2": [
                                    {"uuid": "UUID2", "name": "The name of the model entry", "model1s": ["UUID1"]}
                                ],
                                "emotion": "Joy"
                            }
                            Emotion values must always be one word.  The response should only ever contain one emotion.
                    In "models2": ["UUID2"], "models2" is the name of the model that model has a relationship with. In "model1s": ["UUID1"], "model1s" is the name of the model that has a relationship with the current model.  So please change those to appropriate names.  It should be a plural noun matching the model name.
                    Return empty arrays if there's no obvious match in the text. Do not include the name of the model in the name of the entry, or any close name - focus on the content of the entry. Use natural language in the names. They should be human readable. The value of name properties should be around 5 words or less but it's not strict. If there are multiple entries that are basically the same, use the first only.
                    You will be recieving a set of user statements as a paragraph.  
                    """
                ],
                [
                    "role": "system",
                    "content": """
                        You are a trauma-informed listener. You have a deep understanding of PTSD and these concepts, which are the models to be used by the developer role to convert natural language into JSON:
                            - triggers
                                Has flashbacks
                            - flashbacks
                                Has triggers
                            - emotion: pick one from from this list - name should be one word only:
                                Joy
                                Serenity
                                Ecstasy
                                Cheerfulness
                                Contentment
                                Happiness
                                Trust
                                Acceptance
                                Admiration
                                Kindness
                                Friendliness
                                Loyalty
                                Fear
                                Apprehension
                                Terror
                                Nervousness
                                Anxiety
                                Worry
                                Surprise
                                Distraction
                                Amazement
                                Shock
                                Astonishment
                                Wonder
                                Sadness
                                Pensiveness
                                Grief
                                Sorrow
                                Despair
                                Melancholy
                                Disgust
                                Boredom
                                Loathing
                                Aversion
                                Distaste
                                Revulsion
                                Anger
                                Annoyance
                                Rage
                                Irritation
                                Exasperation
                                Hostility
                                Anticipation
                                Interest
                                Vigilance
                                Eagerness
                                Excitement
                                Curiosity
                                Love
                                Affection
                                Adoration
                                Passion
                                Infatuation
                                Fondness
                                Shock
                                Astonishment
                                Wonder
                                Disbelief
                                Amazement
                                Confidence
                                Pride
                                Self-assurance
                                Certainty
                                Courage
                                Boldness
                                Contempt
                                Disdain
                                Scorn
                                Derision
                                Disrespect
                                Disregard
                                Remorse
                                Guilt
                                Regret
                                Shame
                                Contrition
                                Repentance
                                Disappointment
                                Disillusionment
                                Letdown
                                Frustration
                                Regret
                                Resignation
                                Hope
                                Anticipation
                                Optimism
                                Expectation
                                Desire
                                Aspiration
                                Gratitude
                                Thankfulness
                                Appreciation
                                Recognition
                                Gratefulness
                                Obligation
                                Jealousy
                                Envy
                                Covetousness
                                Resentment
                                Insecurity
                                Suspicion
                    """
                ],
                [
                    "role": "user",
                    "content": promptText
                ]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response JSON: \(responseJSON)")
                    
                    if let choices = responseJSON["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        completion(content)
                        print("Response: \(content)")
                    } else {
                        print("Invalid response format")
                        completion(nil)
                    }
                } else {
                    print("Failed to parse JSON")
                    completion(nil)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
