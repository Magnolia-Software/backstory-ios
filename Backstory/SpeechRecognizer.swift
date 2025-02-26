//
//  SpeechRecognizer.swift
//  Backstory
//
//  Created by Candace Camarillo on 2/25/25.
//

import Speech
import AVFoundation

class SpeechRecognizer: NSObject, SFSpeechRecognizerDelegate {
    static let shared = SpeechRecognizer()
    
    private let audioEngine = AVAudioEngine()
    public var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private(set) var transcription: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.transcriptionUpdateHandler?(self.transcription)
            }
        }
    }
    var transcriptionUpdateHandler: ((String) -> Void)?
    
    override init() {
        super.init()
        
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        speechRecognizer?.delegate = self
    }
    
    func startRecording() {
        
        print("LINE 29")
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.requiresOnDeviceRecognition = false
        recognitionRequest?.shouldReportPartialResults = true
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session properties weren't set because of an error.")
        }
        
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            fatalError("Speech recognizer is not available")
        }
        
        print("start recogition")
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                print("transcription: " + result.bestTranscription.formattedString)
                //self.transcription = result.bestTranscription.formattedString
                
                DispatchQueue.main.async {
                    self.transcription = result.bestTranscription.formattedString // Update the state variable with the final transcription
                    print("TEST: \(self.transcription)")
                }
            }
            
            if let error = error {
                print("recognition error: " + error.localizedDescription)
            }
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audio engine could not start")
        }
        
        print("Recording started.")
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        print("recording stopped")
        self.transcription = SpeechRecognizer.shared.transcription
        //print(transcription)
        
    }
}
