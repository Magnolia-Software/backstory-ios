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
    private let classificationService = ClassificationService()
    
    var transcriptionUpdateHandler: ((String) -> Void)? // can be any function that returns a String
    private(set) var transcription: String = "" { // publishes for Listen view to use
        didSet {
            DispatchQueue.main.async {
                self.transcriptionUpdateHandler?(self.transcription)
            }
        }
    }
    
    var tokensUpdateHandler: (([String]) -> Void)? // can be any function that returns an array of strings
    private(set) var tokens: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tokensUpdateHandler?(self.tokens)
            }
        }
    }
    
    var transcriptionWithPunctuationUpdateHandler: ((String) -> Void)? // can be any function that returns a String
    private(set) var transcriptionWithPunctuation: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.transcriptionWithPunctuationUpdateHandler?(self.transcriptionWithPunctuation)
            }
        }
    }
    
    var sentimentUpdateHandler: ((String) -> Void)?
    private(set) var sentiment: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.sentimentUpdateHandler?(self.sentiment)
            }
        }
    }
    
    var sentimentsUpdateHandler: (([String]) -> Void)?
    private(set) var sentiments: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.sentimentsUpdateHandler?(self.sentiments)
            }
        }
    }
    
    /**
        NOT IN USE: An array of paragraphs.
     */
    var paragraphTokensUpdateHandler: (([String]) -> Void)? // can be any function that returns a String
    private(set) var paragraphTokens: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.paragraphTokensUpdateHandler?(self.paragraphTokens)
            }
        }
                
    }
    
    override init() {
        super.init()
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        speechRecognizer?.delegate = self
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
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.transcription = self.processTranscriptionFeed(in: result.bestTranscription.formattedString)
            }
            
            if let error = error {
                if error.localizedDescription != "Recognition request was canceled" {
                    print("recognition error: " + error.localizedDescription)
                }
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
    
    
    private func addLastToken(from words: [String], processedTranscription: String) -> [String] {
        
        var tokens = self.tokens
        
        if var lastToken = tokens.last {
            if let lastWord = words.last {
                lastToken += " " + lastWord
                
                if let lastWordFromLastToken = tokens.last?.split(separator: " ").last {
                    if lastWordFromLastToken == lastWord {
                    } else {
                        if let lastToken = tokens.last, let lastWord = words.last {
                            if let lastWordInToken = lastToken.split(separator: " ").last, lastWordInToken != lastWord {
                                let string = lastToken + " " + lastWord
                                tokens[tokens.count - 1] = string
                            }
                        } else {
                            tokens.append(processedTranscription)
                        }
                    }
                } else {
                    if let lastWord = words.last {
                        lastToken += " " + lastWord
                        tokens[tokens.count - 1] = lastToken
                    }
                }
                
            }
        } else {
            if var lastToken = tokens.last {
                if let lastWord = words.last {
                    lastToken += " " + lastWord
                    tokens[tokens.count - 1] = lastToken
                }
            } else {
                tokens.append(String(words.last ?? ""))
            }
        }
        
        return tokens
    }
    
    /**
     Populates the tokens array with the processed transcription.
     */
    private func populateTokens(from processedTranscription: String) -> [String] {
        
        var tempTokens = self.tokens
        var processedTranscription = processedTranscription
        
        processedTranscription = self.addLineBreakAfterSecondToLastWord(in: processedTranscription)
        
        let wordsAfterLastLineBreak = processedTranscription.split(separator: "\n").last ?? ""
        let wordsBeforeLastLineBreak = processedTranscription.split(separator: "\n").dropLast().joined(separator: "\n")

        if var lastToken = self.tokens.last {
            tempTokens.append(String(wordsAfterLastLineBreak))
        } else {
            tempTokens.append(String(wordsBeforeLastLineBreak))
        }
        
        return tempTokens
        
    }
    
    /*
        Detects pauses in the transcription and adds line breaks accordingly.
        Runs on every word, each time it's transcribed
        Adds punctuation to the transcription
        Updates a list of tokens - those are what will be fed into the natural language processor
        @param  transcription - the transcription string to process
        @return String - the processed transcription with pauses detected
     */
    private func processTranscriptionFeed(in transcription: String) -> String {
        
        let words = transcription.split(separator: " ")
        var processedTranscription = ""
        var sentence = ""
        var lastWordTime: TimeInterval = Date().timeIntervalSince1970
        
        for word in words {
            let currentTime = Date().timeIntervalSince1970
            let timeDifference = currentTime - lastWordTime
            sentence += "\(word) "
            
            if timeDifference > 0.00005 {
                processedTranscription += sentence.trimmingCharacters(in: .whitespaces)
                sentence = ""
            }

            lastWordTime = currentTime
        }
    
        if !sentence.isEmpty {
            processedTranscription += sentence.trimmingCharacters(in: .whitespaces)
        }
        
        if self.shouldLineBreak(from: transcription) {
            
            self.tokens = self.populateTokens(from: processedTranscription)
            
            let processor = TokenProcessor()
            
            print("TOKENS!!")
            for token in self.tokens {
                print("token: \(token)")
            }
            
            for token in self.tokens {
                
                let punctuatedText = processor.addPunctuation(to: token)
                self.transcriptionWithPunctuation += " " + punctuatedText
            }
            
            //if let sentimentAnalysis = SentimentAnalysis() {
                //if let lastToken = self.tokens[self.tokens.count - 1] ?? {
                let lastCompleteToken = self.tokens[self.tokens.count - 2]
                //if lastToken {
                    //let sentiment = sentimentAnalysis.analyzeSentiment(for: punctuatedText)
                    //let sentiment = sentimentAnalysis.analyzeSentiment(for: lastToken)
                    let sentiment = classificationService.predictSentiment(from: lastCompleteToken)
                    //self.sentiment = sentiment
                    print("sentiment!!!")
                    //self.sentiment = \(sentiment)
                    // convert sentiment to string
                    self.sentiment = "\(sentiment)"
                    self.sentiments.append("\(sentiment)")
            
            
                    //print("lastToken: \(lastToken)")
                    print("sentiment for \(lastCompleteToken)")
                //} else {
                //    print("This is a repeat")
                //}
            //} else {
                print("Could not create sentiment analysis object")
            //}
            
            
            
        } else {
            self.tokens = self.addLastToken(from: words.map { String($0) }, processedTranscription: processedTranscription)
        }
        
        //let lastToken = self.tokens.last ?? ""
        
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
