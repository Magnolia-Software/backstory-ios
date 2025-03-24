//
//  ListenView.swift
//  Backstory
//
//  Created by Candace Camarillo on 2/25/25.
//

import SwiftUI
import Speech
import CoreData
import UIKit

class Listen: ObservableObject {
    @Published var router: Router
    @Published var isListening = false
    @Published var transcription = ""
    @Published var tokens: [String] = []
    @Published var transcriptionWithPunctuation = ""
    @Published var paragraphTokens: [String] = [] // UNUSED: an array of paragraphs
    @Published var sentiment = ""
    @Published var sentiments: [String] = []
    @Published var prompt: String = ""
    @Published var response: String = ""
    @Published var isLoadingAIResponse: Bool = false
    @Published var changeCounter: Int = 0
    @Published var emotionName = ""
    @Published var emotionColor = "#ffffff"
    @Published var phase: CGFloat = 0
    @Published var heartPulse: CGFloat = 2
    
    init(router: Router) {
        self.router = router
    }
    
    var circleSize: CGFloat {
        switch sentiment.lowercased() {
        case "positive":
            return 240
        case "negative":
            return 160
        default:
            return 200
        }
    }
    
    var pulseDuration: Double {
        switch sentiment.lowercased() {
        case "positive":
            return 3.0
        case "negative":
            return 1.0
        default:
            return 2.0
        }
    }
    
    func stopListening() {
        print("stop listening")
        phase = 0
        SpeechRecognizer.shared.stopRecording()
        isListening = false // issue: view does not update here
        DispatchQueue.main.async {
            self.transcription = SpeechRecognizer.shared.transcription // Update the state variable with the final transcription
        }
    }
    
    func startListening(toastManager: ToastManager) {
        // reset to neutral
        emotionColor = "#ffffff"
        print("start listening")
        withAnimation {
            phase = .pi * 2
            print("phase = \(phase)")
        }
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                self.requestMicrophonePermission { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.isListening.toggle()
                            let speechRecognizer = SpeechRecognizer.shared
                            speechRecognizer.transcriptionUpdateHandler = { newTranscription in
                                self.transcription = newTranscription
                            }
                            speechRecognizer.tokensUpdateHandler = { tokens in
                                self.tokens = tokens
                            }
                            speechRecognizer.transcriptionWithPunctuationUpdateHandler = { transcriptionWithPunctuation in
                                self.transcriptionWithPunctuation = transcriptionWithPunctuation
                            }
                            speechRecognizer.paragraphTokensUpdateHandler = { paragraphTokens in
                                self.paragraphTokens = paragraphTokens
                            }
                            speechRecognizer.sentimentUpdateHandler = { sentiment in
                                self.sentiment = sentiment
                            }
                            speechRecognizer.sentimentsUpdateHandler = { sentiments in
                                self.sentiments = sentiments
                            }
                            if speechRecognizer.speechRecognizer?.isAvailable == true {
                                speechRecognizer.startRecording()
                            }
                        }
                    } else {
                        print("microphone request denied")
                        toastManager.showToast(message: "This app requires speech recognition permission to function.  Please authorize speech recognition to continue. (Denied)")
                    }
                }
            case .denied:
                toastManager.showToast(message: "This app requires speech recognition permission to function.  Please authorize speech recognition to continue. (Denied)")
            case .restricted:
                toastManager.showToast(message: "This app requires speech recognition permission to function.  Please authorize speech recognition to continue. (Restricted)")
            case .notDetermined:
                toastManager.showToast(message: "This app requires speech recognition permission to function.  Please authorize speech recognition to continue. (Not Determined)")
            @unknown default:
                toastManager.showToast(message: "An unhandled error occurred.")
                fatalError("Unknown authorization status")
            }
        }
    }
    
    private func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func processTranscription(_ transcription: String) {
        var doFetch = false
        if self.changeCounter == 0 || self.changeCounter % 5 == 0 {
            doFetch = true
        }
        if doFetch {
            let statements = StatementManager.shared.fetchUnprocessedStatements()
            let json = [
                "statements": statements.map { statement in
                    return statement.text ?? ""
                }
            ]
            if statements.count > 0 {
                makeAPIRequest(with: json)
            }
        }
        self.changeCounter += 1
    }
    
    func makeAPIRequest(with prompt: [String: [String]]) {
        self.isLoadingAIResponse = true
        OpenAI.shared.makeRequest(prompt: prompt) { response in
            DispatchQueue.main.async {
                self.isLoadingAIResponse = false
                guard let response = response else {
                    return
                }
                self.response = response
            }
        }
    }
}

/**
    The Listen view is responsible for handling the speech recognition functionality.
    It provides a user interface to start and stop listening, and displays the transcribed text.
 */
struct ListenView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var toastManager: ToastManager
    @ObservedObject var listenViewModel: Listen
    
//    init(router: Router) {
//        _listenViewModel = ObservedObject(wrappedValue: Listen(router: router))
//    }
    
    var body: some View {
        VStack {
            Heading1TabsText(text: "Listen", iconName: "waveform")
            VStack {
                if !listenViewModel.isListening {
                    Heading2Text(text: "Backstory can listen and offer trauma-informed insights.")
                    BodyText(text: "Press \"Listen\" to begin.  We'll offer insights as you speak.")
                        .padding(.bottom, 20)
                }
                
                if listenViewModel.isListening {
                    Spacer()
                    ZStack {
                        PulsingHeart(emotionColor: Color(UIColor(hex: listenViewModel.emotionColor)),
                                     pulseDuration: listenViewModel.pulseDuration)
                        Circle()
                            .stroke(Stylesheet.Colors.heading1, lineWidth: 10) // Bottom circle with stroke
                            .frame(width: listenViewModel.circleSize, height: listenViewModel.circleSize) // Slightly larger than the top circle
                            .animation(.easeInOut(duration: 1.5), value: listenViewModel.circleSize)
                        if (listenViewModel.emotionName != "") {
                            Text(listenViewModel.emotionName)
                                .foregroundColor(Color(UIColor(hex: listenViewModel.emotionColor).contrastingTextColor))
                                .animation(.easeInOut(duration: 1.0), value: listenViewModel.emotionName)
                        }
                    }
                    .frame(width: 240, height: 240)
                    .padding(.bottom, 40)
                }
                
                ActionButton(title: listenViewModel.isListening ? "Listening.  Click to Stop." : "Listen", action: {
                    if listenViewModel.isListening {
                        listenViewModel.stopListening()
                    } else {
                        listenViewModel.startListening(toastManager: toastManager)
                    }
                }, position: "center")
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .onChange(of: listenViewModel.transcriptionWithPunctuation) { _, newValue in
                listenViewModel.processTranscription(newValue)
            }
            .onChange(of: listenViewModel.response) { _, newValue in
                let openAI = OpenAI()
                let formattedResponse = openAI.processOpenAIResponse(newValue)
                listenViewModel.emotionName = formattedResponse.emotion.name
                listenViewModel.emotionColor = formattedResponse.emotion.color
            }
        }
        .background(Stylesheet.Colors.background)
    }
}

// Helper to convert HEX color code to Color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
    

}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

    // Convert hex string to UIColor
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = (rgb >> 16) & 0xFF
        let green = (rgb >> 8) & 0xFF
        let blue = rgb & 0xFF

        self.init(
            red: Int(red),
            green: Int(green),
            blue: Int(blue)
        )
    }
    
    func isLight() -> Bool {
        guard let components = cgColor.components, components.count >= 3 else {
            return false
        }
        
        let red = components[0] * 299
        let green = components[1] * 587
        let blue = components[2] * 114
        let brightness = (red + green + blue) / 1000
        
        return brightness > 0.5
    }
    
    var contrastingTextColor: UIColor {
        return isLight() ? .black : .white
    }
}

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

          // THIS WORKS!
//        let openAIAPIKey: String? = {
//                return ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
//        }()
//
//        if let apiKey = openAIAPIKey {
//            print("API Key: \(apiKey)")
//        } else {
//            print("API Key not found")
//        }

      // Example usage of OpenAIRequest
//        OpenAI.shared.makeRequest(prompt: "This is something") { result in
//            isLoadingAIResponse = true
//            DispatchQueue.main.async {
//                if let result = result {
//                    response = result
//                    print("response")
//                } else {
//                    response = "Failed to get a response."
//                }
//                isLoadingAIResponse = false
//            }
//        }
