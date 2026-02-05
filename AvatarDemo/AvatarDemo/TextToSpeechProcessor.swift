//
//  TextToSpeechProcessor.swift
//  AvatarDemo
//
//  Created by Sergio on 15.06.24.
//

import AVFoundation

class TextToSpeechProcessor: NSObject, AVSpeechSynthesizerDelegate {
    private var speechSynthesizer: AVSpeechSynthesizer
    private var shapeKeyAnimator: ShapeKeyAnimator?
    private let configuration: AvatarConfiguration

    init(configuration: AvatarConfiguration) {
        self.configuration = configuration
        self.speechSynthesizer = AVSpeechSynthesizer()
        super.init()
        self.speechSynthesizer.delegate = self
    }

    func processAndReadText(_ text: String, animator: ShapeKeyAnimator?) {
        self.shapeKeyAnimator = animator
        let syllables = SyllableProcessor.processTextToSyllables(text)
        let totalDuration = estimateSpeechDuration(for: text)
        shapeKeyAnimator?.animateSyllables(syllables, totalDuration: totalDuration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.3  // Slower speech rate (default is 0.5)
            self.speechSynthesizer.speak(utterance)
        }
    }

    private func estimateSpeechDuration(for text: String) -> TimeInterval {
        // Adjust words per minute based on speech rate (0.3 is slower than default 0.5)
        // At rate 0.3, speech is about 60% of normal speed
        let baseWordsPerMinute: Double = 250.0
        let speechRate: Double = 0.3
        let normalRate: Double = 0.5
        let adjustedWordsPerMinute = baseWordsPerMinute * (speechRate / normalRate)

        let words = text.split { $0.isWhitespace || $0.isPunctuation }.count
        let minutes = Double(words) / adjustedWordsPerMinute
        return minutes * 60.0
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // Reset or perform any necessary actions after TTS finishes
    }
}
