//
//  OpenAI.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/5/25.
//

import Foundation

class OpenAI {
    
    static let shared = OpenAI()
    
    private init() {}
    
    func makeRequest(prompt: String, completion: @escaping (String?) -> Void) {
            print("Starting request with prompt: \(prompt)")
            
            let url = URL(string: "https://api.openai.com/v1/chat/completions")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
            // get API token from enironment
//            request.setValue("Bearer \(String(describing: ProcessInfo.processInfo.environment["OPENAI_API_KEY"]))", forHTTPHeaderField: "Authorization")
//            print("Bearer \(String(describing: ProcessInfo.processInfo.environment["OPENAI_API_KEY"]))")
            
            if let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] {
                request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            } else {
                print("API key is missing")
                completion(nil)
                return
            }
        
            let parameters: [String: Any] = [
                "model": "gpt-4o-mini",
                "messages": [
                    [
                        "role": "developer",
                        "content": """
                            You are an expert in data translation from natural language into JSON.  You work with the the trauma-informed models that are provided by the system role. Look at the system prompt for the model names.  Use your smarts to convert the natural language user prompt into JSON for output.  Follow this general JSON format:
                                {
                                    "model1": [
                                        {"uuid": "UUID1", "name": "A name for the model entry", "models2": ["UUID2]}
                                    ], 
                                    "model2": [
                                        {"uuid": "UUID2", "name": "The name of the model entry", "model1s": ["UUID1"]}
                                    ]
                                }
                        Return empty arrays if there's no obvious match in the text. Do not include the name of the model in the name of the entry, or any close name - focus on the content of the entry. Use natural language in the names. They should be human readable. The value of name properties should be around 5 words or less but it's not strict.  If there are multiple entries that are basically the same, use the first only.
                        """
                    ],
                    [
                        "role": "system",
                        "content": """
                            You are a trauma-informed listener.  You have a deep understanding of PTSD and these concepts, which are the models to be used by the developer role to convert natural language into JSON:
                                - triggers
                                    Has flashbacks
                                - flashbacks
                                    Has triggers
                        """
                    ],
                    [
                        "role": "user",
                        "content": "When my mom yells at me, I flash back to when I was a kid and my dad yelled at me."
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
