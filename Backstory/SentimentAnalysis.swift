import CoreML

class SentimentAnalysis {
    private var sentimentModel: MLModel?

    init?() {
        guard let modelUrl = Bundle.main.url(forResource: "SentimentPolarity", withExtension: "mlmodelc") else {
            print("Model file not found in bundle.")
            return nil
        }
        do {
            sentimentModel = try MLModel(contentsOf: modelUrl)
        } catch {
            print("Failed to load model: \(error)")
            return nil
        }
    }

    func preprocess(text: String) -> [String: Double] {
//        // Example preprocessing: tokenization and feature extraction
//        let tokens = text.lowercased().split(separator: " ")
//        var features: [String: Double] = [:]
//        for token in tokens {
//            features[String(token)] = (features[String(token)] ?? 0) + 1.0
//        }
//        print("Preprocessed features: \(features)")
        let features: [String: Double] = [text: 1.0]
        print("features")
        print(features)
        return features
    }

    func analyzeSentiment(for text: String) -> String {
        guard let sentimentModel = sentimentModel else {
            return "Model not loaded"
        }
        
        print("here I am!")
        print("text")
        print(text)
        let features = preprocess(text: text)
        do {
            // Ensure the input matches the expected input name in the model
            let inputFeatures = try MLDictionaryFeatureProvider(dictionary: ["input": features])
            let prediction = try sentimentModel.prediction(from: inputFeatures)
            print("----------------------")
            print(prediction)
            if let sentiment = prediction.featureValue(for: "classLabel")?.stringValue {
                print("Predicted sentiment: \(sentiment)")
                return sentiment
            } else {
                print("No sentiment label found in prediction.")
                return "Neutral"
            }
        } catch {
            print("Failed to make prediction: \(error)")
            return "Error"
        }
    }
}
