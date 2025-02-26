//
//  ListenView.swift
//  Backstory
//
//  Created by Candace Camarillo on 2/25/25.
//

import SwiftUI
import Speech

struct Listen: View {
    @StateObject var router: Router
    @State private var isListening = false
    @EnvironmentObject var toastManager: ToastManager
    @State private var transcription = ""
    
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
                        Text(transcription)
                            .foregroundColor(Color.white)
                            .padding()
                        Button(action: {
//                            print("HELLLLLL")
//                            if isListening {
//                                print("is listening")
//                            }
//                            withAnimation {
//                                if isListening {
//                                    
//                                    stopListening()
//                                } else {
//                                    startListening()
//                                }
//                                
//                            }
//                            isListening.toggle()
                            //print("MY OH MY")
                            
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
    
    private func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    private func stopListening() {
        print("stopping recording")
        SpeechRecognizer.shared.stopRecording()
        print("got here")
        isListening = false
        
        DispatchQueue.main.async {
            transcription = SpeechRecognizer.shared.transcription // Update the state variable with the final transcription
        }

    }
    
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
                            
                            if speechRecognizer.speechRecognizer?.isAvailable == true {
                                print("Starting speech recognizer")
                                //toastManager.showToast(message: "Starting speech recognizer")
                                speechRecognizer.startRecording()
                            }
                        }
                        
                        /*
                        
                        isListening.toggle()
                        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
                        print("TEST")
                        
                        if let recognizer = speechRecognizer {
                            print("helllllllliiiiiii")
                            if recognizer.isAvailable {
                                print("Starting speech recognizer")
                                let speechRecognizer = SpeechRecognizer()
                                speechRecognizer.startRecording()
                                print("recording!")
                                
                                //isListening = true

                            } else {
                                print("speech reognition not available")
                                toastManager.showToast(message: "Speech recognition is unavailable.")
                            }
                        } else {
                            print("intiialziae speech recgonizer")
                            toastManager.showToast(message: "unable to initialize speechRecognizer")
                        }
                        
                        */
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
