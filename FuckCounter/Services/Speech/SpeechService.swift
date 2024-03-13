//
//  SpeechService.swift
//  FuckCounter
//
//  Created by Alex on 15.12.2023.
//

import Foundation
import Speech
import SwiftUI

//enum SpeechServiceError: LocalizedError {
//    case audioEngineError
//    case speechRecognitionError
//    case speechAvailableError
//    case speechDeniedError
//    
//    var errorDescription: String? {
//        switch self {
//        case .audioEngineError:
//            return "There has been an audio engine error."
//        case .speechRecognitionError:
//            return "Speech recognition is not supported for your current locale."
//        case .speechAvailableError:
//            return "Speech recognition is not currently available. Check back at a later time."
//        case .speechDeniedError:
//            return "You have disabled access to speech recognition."
//        }
//    }
//}

class SpeechService: ObservableObject {
    
//    let audioEngine = AVAudioEngine()
//    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: AppData.selectedLanguageModel.languageCode))
//    let request = SFSpeechAudioBufferRecognitionRequest()
//    var recognitionTask: SFSpeechRecognitionTask?
    @Published var isRecording: Bool
    @Published var error: String?
    @Published var fullText: String?
    
    var speechRecognizer = SwiftSpeechRecognizer.live
    
    init() {
        self.isRecording = false
    }
    
    func updateSpeechLocale() {
        speechRecognizer = SwiftSpeechRecognizer.live
//        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: AppData.selectedLanguageModel.languageCode))
    }
    
    func requestSpeechAuthorization(handler: ((SFSpeechRecognizerAuthorizationStatus) -> Void)?) {
        speechRecognizer.requestAuthorization()
        
        Task {
            for await authorizationStatus in speechRecognizer.authorizationStatus() {
                handler?(authorizationStatus)
            }
        }
    }
    
    func startRecording() {
        do {
            try speechRecognizer.startRecording()
            
            Task {
                for await recognitionStatus in speechRecognizer.recognitionStatus() {
                    isRecording = recognitionStatus == .recording
                    if recognitionStatus == .stopped {
                        fullText = nil
                    }
                }
            }
            
            Task {
                for await newUtterance in speechRecognizer.newUtterance() {
                    debugPrint(newUtterance)
                    self.fullText = newUtterance
                }
            }
            
        } catch let error {
            
            self.error = error.localizedDescription
            self.isRecording = false
            speechRecognizer.stopRecording()
        }
//            let clean = bestString.filter{ $0.isLetter || $0.isWhitespace }
//
//            if let lastIndex = clean.lastIndex(of: " "), 
//                let index = clean.index(lastIndex, offsetBy: 1, limitedBy: clean.index(before: clean.endIndex)) {
//                let lastWord = clean[index...]
//                
//                debugPrint(lastWord)
//                if lastWord.lowercased() == AppData.selectedWordsModel.name.lowercased() {
//                    self.isSameWord = true
//                }
//            } else {
//                if bestString.lowercased() == AppData.selectedWordsModel.name.lowercased() {
//                    self.isSameWord = true
//                }
//            }
    }
    
    func stopRecording() {
        speechRecognizer.stopRecording()
    }
    
    func pauseRecording() {
        do {
            try speechRecognizer.pauseRecording()
        } catch let error {
            self.error = error.localizedDescription
        }
//        audioEngine.pause()
//        do {
//            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
//        } catch let error {
//            self.error = error.localizedDescription
//            debugPrint(error.localizedDescription)
//        }
    }
    
    func resumeRecording() {
        do {
            try speechRecognizer.resumeRecording()
        } catch let error {
            self.error = error.localizedDescription
        }

//        do {
//            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
//            try audioEngine.start()
//        } catch let error {
//            self.error = error.localizedDescription
//            debugPrint(error.localizedDescription)
//        }
    }
}
