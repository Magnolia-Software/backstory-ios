//
//  ListenView.swift
//  Backstory
//
//  Created by Candace Camarillo on 2/25/25.
//

import SwiftUI
import Speech

/**
    The Listen view is responsible for handling the speech recognition functionality.
    It provides a user interface to start and stop listening, and displays the transcribed text.
 */
struct Listen: View {
    @StateObject var router: Router
    @State private var isListening = false
    @EnvironmentObject var toastManager: ToastManager
    @State private var transcription = ""
    @State private var tokens: [String] = []
    @State private var transcriptionWithPunctuation = ""
    @State private var paragraphTokens: [String] = [] // UNUSED: an array of paragraphs
    
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
                        Text("It's time to start speaking your truth.")
                            .foregroundColor(Color.white)
                            .padding(50)
                            .opacity(isListening ? 0 : 1)
                            .frame(height: isListening ? 0 : nil)
                            .clipped()
                            .animation(.easeInOut(duration: 1.0), value: isListening)
                        // tokens (phrases between 1 second pauses) as a list
                        if isListening {
                            List(tokens, id: \.self) { token in
                                Text(token)
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                            }
                        }
//
                        Text(transcriptionWithPunctuation)
                        if isListening {
                            List(paragraphTokens, id: \.self) { token in
                                Text(token)
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                            }
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
        Stops the speech recognition and updates the transcription.
        - Returns: Void
    */
    private func stopListening() {
        print("stopping recording")
        SpeechRecognizer.shared.stopRecording()
        print("got here")
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
