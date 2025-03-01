import NaturalLanguage

class TokenProcessor {
    var tokens: [String] = []
    
    func addPunctuation(to text: String) -> String {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        var punctuatedText = ""
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
            let sentence = text[tokenRange]
            let punctuatedSentence = self.addPunctuationToSentence(String(sentence))
            punctuatedText += punctuatedSentence + " "
            return true
        }
        return punctuatedText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func addPunctuationToSentence(_ sentence: String) -> String {
        // Simple heuristic-based punctuation restoration
        var punctuatedSentence = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
        if !punctuatedSentence.hasSuffix(".") && !punctuatedSentence.hasSuffix("!") && !punctuatedSentence.hasSuffix("?") {
            punctuatedSentence += "."
        }
        return punctuatedSentence
    }
}
