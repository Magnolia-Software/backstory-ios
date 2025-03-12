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
/**
    The Listen view is responsible for handling the speech recognition functionality.
    It provides a user interface to start and stop listening, and displays the transcribed text.
 */
struct Listen: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var router: Router
    @State private var isListening = false
    @EnvironmentObject var toastManager: ToastManager
    @State private var transcription = ""
    @State private var tokens: [String] = []
    @State private var transcriptionWithPunctuation = ""
    @State private var paragraphTokens: [String] = [] // UNUSED: an array of paragraphs
    @State private var sentiment = ""
    @State private var sentiments: [String] = []
    @State private var prompt: String = ""
    @State private var response: String = ""
    @State private var isLoadingAIResponse: Bool = false
    @State private var changeCounter: Int = 0
    //@ObservedObject var emotionViewModel = EmotionViewModel()
    //@ObservedObject var emotionManager = EmotionManager.shared
    //@ObservedObject var emotionManager = EmotionManager.shared
    @State private var emotionName = ""
    @State private var emotionColor = "#eeeeee"
        
    var body: some View {
        
            // WHOLE WINDOW FRAME BG COLOR
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(width: UIScreen.main.bounds.width)
                .background(isListening ? Color(UIColor(hex: emotionColor)) : Color.red)
                .foregroundColor(Color.white)
                .font(.largeTitle)
                .animation(.easeInOut(duration: 1.0), value: isListening)
                .animation(.easeInOut(duration: 2.0), value: emotionColor)
            VStack {
                ZStack {
                    VStack {
                        Spacer()
                        Text("Ready to Listen")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .opacity(isListening ? 0 : 1)
                            .frame(height: isListening ? 0 : nil)
                            .clipped()
                            .animation(.easeInOut(duration: 1.0), value: isListening)
                        Text(sentiment)
                            .foregroundColor(Color.blue)
                            .background(Color.white)
                            .padding(50)
                        Text("It's time to start speaking your truth.")
                            .foregroundColor(Color.white)
                            .padding(50)
                            .opacity(isListening ? 0 : 1)
                            .frame(height: isListening ? 0 : nil)
                            .clipped()
                            .animation(.easeInOut(duration: 1.0), value: isListening)
                        //Text("EmotionManager shared: \(emotionManager)")
                        
                        
                        // tokens (phrases between 1 second pauses) as a list
                        if isListening {
//                            List {
//                                if let emotions = emotionViewModel.emotionWheel?.emotions {
//                                    ForEach(emotions) { emotion in
//                                        Section(header: Text(emotion.name).font(.headline).padding(.leading, 8)) {
//                                            EmotionRow(emotion: emotion)
//                                            ForEach(emotion.secondary) { secondaryEmotion in
//                                                SecondaryEmotionRow(secondaryEmotion: secondaryEmotion)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            List {
//                                if let emotions = emotionViewModel.emotionWheel?.emotions {
//                                    ForEach(emotions) { emotion in
//                                        EmotionRow(emotion: emotion)
//                                    }
//                                }
//                            }
                            Text("EmotionName: \(emotionName)")
                                .foregroundColor(Color.blue)
                                .background(Color.white)
                                .padding(50)
                            Text("Emotion Color: \(emotionColor)")
                            List(sentiments, id: \.self) { sentiment in
                                Text(sentiment)
                                    .foregroundColor(Color.black)
                                    .background(Color.yellow)
                            }
                            List(tokens, id: \.self) { token in
                                Text(token)
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                            }
                        }
                        Text(transcriptionWithPunctuation)
                        if isListening {
                            List(paragraphTokens, id: \.self) { token in
                                Text(token)
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                            }
                            Text("OPENAPI response: \(response)")
                                .foregroundColor(Color.black)
                                .background(Color.white)
                        }
                        Button(action: {
                            if isListening {
                                stopListening()
                            } else {
                                startListening()
                            }
                        }) {
                            Text(isListening ? "Listening.  Click to Stop." : "Start")
                                .font(.title)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
   
                }
            }
            .onChange(of: transcriptionWithPunctuation) { oldValue, newValue in processTranscription(newValue)
            }
            .onChange(of: response) { oldValue, newValue in
                //processOpenAIResponse(newValue)
                let openAI = OpenAI()
                let formattedRepsonse = openAI.processOpenAIResponse(newValue)
                self.emotionName = formattedRepsonse.emotion.name
                self.emotionColor = formattedRepsonse.emotion.color
            }
    }
    
    struct EmotionRow: View {
        let emotion: Emotion2
        
        var body: some View {
            HStack {
                Color(UIColor(hex: emotion.color))
                    .frame(width: 20, height: 20)
                    .cornerRadius(5)
                Text(emotion.name)
                    .padding(.leading, 8)
            }
        }
    }
    
    /**
        Requests microphone permission from the user.
        param completion: A closure that is called with the result of the permission request.
        - Parameter granted: A Boolean value indicating whether the permission was granted.
        - Returns: Void
     */
    private func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    /**
    Sends the last 5 statements unprocessed to the API for processing
    - Parameter transcription: The transcribed text with punctuation.
     */
    private func processTranscription(_ transcription: String) {
        
        var doFetch = false
        
        if self.changeCounter == 0 || self.changeCounter % 5 == 0 {
            doFetch = true
        }
        
        if doFetch {
            let statements = StatementManager.shared.fetchUnprocessedStatements()
            
            let json = [
                "statements": statements.map { statement in
                    return
                        statement.text ?? ""
                    
                }
            ]
            if statements.count > 0 {
                makeAPIRequest(with: json)
            }
        }
        
        // if the counter is divisible by five, then do not process the transcription
        self.changeCounter += 1
    }

    /**
        Makes an API request to OpenAI with the given prompt.
        - Parameter prompt: A list of prompts to be sent to the OpenAI API.
        - Returns: Void
    */
    private func makeAPIRequest(with prompt: [String : [String]]) {
        self.isLoadingAIResponse = true
        OpenAI.shared.makeRequest(prompt: prompt) { response in
            DispatchQueue.main.async {
                self.isLoadingAIResponse = false
                guard let response = response else {
                    return
                }
                self.response = response
                guard response.data(using: .utf8) != nil else {
                    print("Error: Cannot convert response string to data")
                    return
                }
            }
        }
    }
    
    /**
        Stops the speech recognition and updates the transcription.
        - Returns: Void
    */
    private func stopListening() {
        SpeechRecognizer.shared.stopRecording()
        isListening = false
        
        DispatchQueue.main.async {
            transcription = SpeechRecognizer.shared.transcription // Update the state variable with the final transcription
        }

    }
    
    /**
        Starts the speech recognition process.
        - Returns: Void
    */
    private func startListening() {

        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                
                requestMicrophonePermission { granted in
                    if granted {
                        print("Microphone permission granted")
                        
                        DispatchQueue.main.async {
                            isListening.toggle()
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
}

// Helper to convert HEX color code to Color
extension Color {
    init(hex: String) {
        print(hex)
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
}
