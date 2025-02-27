//
//  SpeechRecognizer.swift
//  Backstory
//
//  Created by Candace Camarillo on 2/25/25.
//

import Speech
import AVFoundation

/**
 SpeechRecognizer - processes audio from the Listen view
 */
class SpeechRecognizer: NSObject, SFSpeechRecognizerDelegate {
    
    static let shared = SpeechRecognizer() // this object
    private let audioEngine = AVAudioEngine()
    public var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private(set) var transcription: String = "" { // publishes for Listen view to use
        didSet {
            DispatchQueue.main.async {
                self.transcriptionUpdateHandler?(self.transcription)
            }
        }
    }
    var transcriptionUpdateHandler: ((String) -> Void)? // can be any function that returns a String
    override init() {
        super.init()
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        speechRecognizer?.delegate = self
    }
    
    var tokensUpdateHandler: (([String]) -> Void)? // can be any function that returns an array of strings
    
    // create an object to hold a set of strings - tokens that represent sentences (split between pauses)
    private(set) var tokens: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tokensUpdateHandler?(self.tokens)
            }
        }
    }
    
    /**
    Start processing the audio to get the live transcription.
    Starts a buffer and stream
    Creates tokens for the language processor to munch.
    Returns nothing.  Requires stopRecording() to clean up properly
     Keeps the transcription updated
     */
    func startRecording() {
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
                self.transcription = self.detectPauses(in: result.bestTranscription.formattedString)
                print("Transcription: \(self.transcription)")
            }
            
            if let error = error {
                print("recognition error: " + error.localizedDescription)
            }
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.removeTap(onBus: 0)
        
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
    
    /**
        Stop the recording process and clean up.
        Updats the transcription object one final time
     */
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        print("recording stopped")
        self.transcription = SpeechRecognizer.shared.transcription
    }
    
    /**
    An array of word/timestamp combinations.
    Used by the detectPauses() function to create tokens of a reasonable size (about a sentance)
     */
    private var wordTimestamps: [(word: String, timestamp: String)] = []
    
    /**
    Looks at the wordTimestaps to determine if a line break should be added to the trascription String
    @param  transcription - the transcription string to process
    @return Bool - true if a line break should be added, false otherwise
     */
    private func shouldLineBreak(from transcription: String) -> Bool {
        let lastWord = transcription.split(separator: " ").last.map { String($0) } ?? "No word"

        let currentTime = Date().timeIntervalSince1970
        let currentTimeString = String(currentTime)
        
        print("Current Time: \(currentTimeString), Last Word: \(lastWord)")
        
        self.wordTimestamps.append((word: lastWord, timestamp: currentTimeString))
        
        if wordTimestamps.count >= 2 {
            let lastTimestampString = wordTimestamps[wordTimestamps.count - 2].timestamp
            if let lastTimestamp = TimeInterval(lastTimestampString) {
                let timeDifference = currentTime - lastTimestamp
                return timeDifference > 1.0
            }
        }

        return false
    }
    
    /**
        Adds line braks to the string based on
     */
//    private func withLineBreaks(in text: String) -> String {
//        let words = text.split(separator: " ")
//        
//        // Check if there are at least two words
//        guard words.count >= 2 else {
//            return text
//        }
//        
//        // Get the second-to-last word index
//        let secondToLastWordIndex = words.count - 2
//        
//        // Reconstruct the string with a line break after the second-to-last word
//        var result = ""
//        for (index, word) in words.enumerated() {
//            result += word
//            if index == secondToLastWordIndex {
//                result += "\n"
//            } else {
//                result += " "
//            }
//        }
//        
//        return result.trimmingCharacters(in: .whitespaces)
//    }
    
    
    /*
        Detects pauses in the transcription and adds line breaks accordingly.
        Runs on every word, each time it's transcribed
        @param  transcription - the transcription string to process
        @return String - the processed transcription with pauses detected
     */
    private func detectPauses(in transcription: String) -> String {
        
        let words = transcription.split(separator: " ")
        var processedTranscription = ""
        var sentence = ""
        var lastWordTime: TimeInterval = Date().timeIntervalSince1970
        
        for word in words {
            let currentTime = Date().timeIntervalSince1970
            let timeDifference = currentTime - lastWordTime
            sentence += "\(word) "
            
            if timeDifference > 0.00005 {
                //processedTranscription += sentence.trimmingCharacters(in: .whitespaces) + "\n"
                processedTranscription += sentence.trimmingCharacters(in: .whitespaces)
                sentence = ""
            }

            lastWordTime = currentTime
        }
    
        if !sentence.isEmpty {
            processedTranscription += sentence.trimmingCharacters(in: .whitespaces)
        }
        
        // add a sentence to the tokens array
        //self.tokens.append(processedTranscription)
        
        //print("TOKENS: \(self.tokens)")
        
        //processedTranscription = self.withLineBreaks(in: processedTranscription)
        
        if self.shouldLineBreak(from: transcription) {
            print("adding line break!")
            
            //self.tokens.append(wordsAfterLastLineBreak)
            processedTranscription = self.addLineBreakAfterSecondToLastWord(in: processedTranscription)
            
            print("processedTranscription with line break: \(processedTranscription)")
        
            
            // get the words after the last line break
            let wordsAfterLastLineBreak = processedTranscription.split(separator: "\n").last ?? ""
            
            let wordsBeforeLastLineBreak = processedTranscription.split(separator: "\n").dropLast().joined(separator: "\n")
        
//            // check if the sentence is already there and only add the last word to the same string in the array
            print("wordsAfterLastLineBreak: \(wordsAfterLastLineBreak)")
//
            //self.tokens.append(String(wordsAfterLastLineBreak))
            if var lastToken = self.tokens.last {
                print("WOW!")
                //lastToken += " " + wordsAfterLastLineBreak
                self.tokens.append(String(wordsAfterLastLineBreak))
            } else {
                self.tokens.append(String(wordsBeforeLastLineBreak))
            }
            
            
            // get the string that is the last token
//            if let lastToken = self.tokens.last {
//                if lastToken.hasPrefix(wordsBeforeLastLineBreak) {
//                    print("last token already contains the words")
//                    // concatenate the wordsAfterLastLineBreak to the value of the last token
//                    self.tokens[self.tokens.count - 1] = lastToken + " " + String(wordsAfterLastLineBreak)
//                    print("new last token: \(self.tokens[self.tokens.count - 1])")
//                    
//                } else {
//                    // start a new token at the end of the last token (string concatenation)
//                    print("adding new token")
//                    self.tokens.append(String(wordsAfterLastLineBreak))
//                    
//                }
//            }
            
            
//            print("last token")
//            //var lastToken = self.tokens.last
//            // look at the lastToken and see if it includes the second to last word at the end of it
//            if String(self.tokens.last).hasSuffix(wordsAfterLastLineBreak) {
//                print("last token already contains the words")
//                // add word to the end of the last token
//                self.tokens.last = self.token.last + " " + String(wordsAfterLastLineBreak)
//            } else {
//                print("adding new token")
//                // add words to a new token
//                self.tokens.append(String(wordsAfterLastLineBreak))
//            }
//            
            // detect if last word is already contained in the tokens array - compare against the last string and see if word or words are at the end of that string
//            if let lastToken = self.tokens.last, lastToken.hasSuffix(String(wordsAfterLastLineBreak)) {
//                print("last token already contains the words")
//                print(lastToken)
//            } else {
//                print("adding new token")
//                // add words to a new token
//                self.tokens.append(String(wordsAfterLastLineBreak))
//            }
                
            
            
            
            
        } else {
            
            // get the last item in tokens
            if var lastToken = self.tokens.last {
                if let lastWord = words.last {
                    lastToken += " " + lastWord
                    
                    // get the last word from the last token
                    if let lastWordFromLastToken = self.tokens.last?.split(separator: " ").last {
                        print("last word from last token: \(lastWordFromLastToken)")
                        // compare the last word from the last token to the last word in the transcription  \
                        if lastWordFromLastToken == lastWord {
                            print("last word from last token: \(lastWordFromLastToken) is the same as the last word in the transcription")
                            //self.tokens[self.tokens.count - 1] = lastToken
                        } else {
  
                            
                            if let lastToken = self.tokens.last, let lastWord = words.last {
                                if lastToken.split(separator: " ").last != lastWord {
                                    print("last word from last token is not the same as the last word in the transcription")
                                    var string = lastToken + " " + lastWord
                                    self.tokens[self.tokens.count - 1] = string
                                }
                            } else {
                                print("appending")
                                print(processedTranscription)
                                self.tokens.append(processedTranscription)
                            }
                        }
                    } else {
                        // add the last word to the last token
                        print("adding last word to last token")
                        if let lastWord = words.last {
                            lastToken += " " + lastWord
                            self.tokens[self.tokens.count - 1] = lastToken
                        }
                        //self.tokens[self.tokens.count - 1] = words.last
                    }
                    
                }
            } else {
                print("adding new token")
                if var lastToken = self.tokens.last {
                    if let lastWord = words.last {
                        lastToken += " " + lastWord
                        print("adding last word \(lastWord) to last token: \(lastToken)")
                        self.tokens[self.tokens.count - 1] = lastToken
                    }
                } else {
                    print("adding new token")
                    self.tokens.append(String(words.last ?? ""))
                }
            }
            
            
        }
        
        print("TOKENS", self.tokens)
        
        return processedTranscription
    }
    
    /**
    Adds a line break after the second-to-last word in the given text.
    @param  text - the text to process
    @return String - the processed text with a line break added
    */
    func addLineBreakAfterSecondToLastWord(in text: String) -> String {
        let words = text.split(separator: " ")
        
        guard words.count >= 2 else {
            return text
        }
        
        let secondToLastWordIndex = words.count - 2
        var result = ""
        for (index, word) in words.enumerated() {
            result += word
            if index == secondToLastWordIndex {
                result += "\n"
            } else {
                result += " "
            }
        }
        
        return result.trimmingCharacters(in: .whitespaces)
    }
}
