//
//  ListenView.swift
//  Backstory
//
//  Created by Candace Camarillo on 2/25/25.
//

import SwiftUI
import Speech
import CoreData

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
    
    var body: some View {
        
            // WHOLE WINDOW FRAME BG COLOR
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(width: UIScreen.main.bounds.width)
                .background(isListening ? Color.red : Color.gray)
                .foregroundColor(Color.white)
                .font(.largeTitle)
                .animation(.easeInOut(duration: 1.0), value: isListening)
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
                        // tokens (phrases between 1 second pauses) as a list
                        if isListening {
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
            .onChange(of: transcriptionWithPunctuation) { oldValue, newValue in processTranscription(newValue)}
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
            // get any unread tokens from the database
            let statements = StatementManager.shared.fetchUnprocessedStatements()
            for statement in statements {
                print("""
                    UNPROCESSED Statement: \(statement.text ?? "empty")
                    """)
            }
            // Create a JSON object with the statements
            let json = [
                "statements": statements.map { statement in
                    return
                        statement.text ?? ""
                    
                }
            ]
            // if there is one or more statements
            if statements.count > 0 {
                // make an API request to the OpenAI API
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
                    //print("Failed to get response from OpenAI API")
                    return
                }
                self.response = response
                // Update the UI with the response or perform any other actions needed
                print("SUCCESS FROM API")
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
        
        // Create a new Flashback
        FlashbackManager.shared.createFlashback(
            name: "flashback 1"
        )
        
        // Fetch all flashbacks
        let flashbacks = FlashbackManager.shared.fetchFlashbacks()
        for flashback in flashbacks {
            print("""
                Flashback Name: \(flashback.name ?? "No Name")
                """)
        }

        
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
                                print("Starting speech recognizer")
                                speechRecognizer.startRecording()
                            }
                        }

                    } else {
                        print("microphone permission denied")
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
