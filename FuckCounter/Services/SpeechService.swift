//
//  SpeechService.swift
//  FuckCounter
//
//  Created by Alex on 15.12.2023.
//

import Foundation
import Speech
import SwiftUI

enum SpeechServiceError: LocalizedError {
    case audioEngineError
    case speechRecognitionError
    case speechAvailableError
    case speechDeniedError
    
    var errorDescription: String? {
        switch self {
        case .audioEngineError:
            return "There has been an audio engine error."
        case .speechRecognitionError:
            return "Speech recognition is not supported for your current locale."
        case .speechAvailableError:
            return "Speech recognition is not currently available. Check back at a later time."
        case .speechDeniedError:
            return "You have disabled access to speech recognition."
        }
    }
}

class SpeechService: ObservableObject {
    
    let audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: AppData.selectedLanguageModel.languageCode))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    @Published var isRecording: Bool
    @Published var error: String?
    @Published var fullText: String?
    
    init() {
        self.isRecording = false
    }
    
    func updateSpeechLocale() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: AppData.selectedLanguageModel.languageCode))
    }
    
    func requestSpeechAuthorization() async -> SFSpeechRecognizerAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        
        node.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionTask?.cancel()
        
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            self.error = SpeechServiceError.audioEngineError.errorDescription
            return
        }

        guard let myRecognizer = SFSpeechRecognizer() else {
            self.error = SpeechServiceError.speechRecognitionError.errorDescription
            self.isRecording = false
            return
        }

        if !myRecognizer.isAvailable {
            self.error = SpeechServiceError.speechAvailableError.errorDescription
            self.isRecording = false
            return
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            
            if let error = error {
                self.error = error.localizedDescription
                self.isRecording = false
                return
            }
            
            if result?.isFinal == true {
                self.cancelRecording()
                return
            }
            
            if !self.isRecording {
                return
            }
            
            guard let result = result else { return }
            
            let bestString = result.bestTranscription.formattedString
            debugPrint(bestString)
            self.fullText = bestString
            
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
        })
    }
    
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        isRecording = false
        fullText = nil
    }
    
    func pauseRecording() {
        audioEngine.pause()
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch let error {
            self.error = error.localizedDescription
            debugPrint(error.localizedDescription)
        }
    }
    
    func resumeRecording() {
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            try audioEngine.start()
        } catch let error {
            self.error = error.localizedDescription
            debugPrint(error.localizedDescription)
        }
    }
}
