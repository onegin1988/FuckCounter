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
    @Published var error: Error?
    @Published var isSameWord: Bool
    
    init() {
        self.isRecording = false
        self.isSameWord = false
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
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            self.error = SpeechServiceError.audioEngineError
            return
        }

        guard let myRecognizer = SFSpeechRecognizer() else {
            self.error = SpeechServiceError.speechRecognitionError
            self.isRecording = false
            return
        }

        if !myRecognizer.isAvailable {
            self.error = SpeechServiceError.speechAvailableError
            self.isRecording = false
            return
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let error = error {
                self.error = error
                self.isRecording = false
                return
            }
            
            if !self.isRecording {
                return
            }
            
            guard let result = result else { return }
            
            let bestString = result.bestTranscription.formattedString
            
            let clean = bestString.filter{ $0.isLetter || $0.isWhitespace }
            
            if let lastIndex = clean.lastIndex(of: " "), 
                let index = clean.index(lastIndex, offsetBy: 1, limitedBy: clean.index(before: clean.endIndex)) {
                let lastWord = clean[index...]
                
                debugPrint(lastWord)
                if lastWord.lowercased() == AppData.selectedWordsModel.name.lowercased() {
                    self.isSameWord = true
                }
            } else {
                if bestString.lowercased() == AppData.selectedWordsModel.name.lowercased() {
                    self.isSameWord = true
                }
            }
        })
    }
    
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        isRecording = false
        isSameWord = false
    }
}
