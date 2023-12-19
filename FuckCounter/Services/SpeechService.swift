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
    let speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    @Published var isRecording: Bool
    @Published var error: Error?
    
    init() {
        self.isRecording = false
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
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            self.error = SpeechServiceError.audioEngineError
            return
        }

        guard let myRecognizer = SFSpeechRecognizer() else {
            self.error = SpeechServiceError.speechRecognitionError
            return
        }

        if !myRecognizer.isAvailable {
            self.error = SpeechServiceError.speechAvailableError
            return
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let error = error {
                self.error = error
                return
            }
            
            guard let result = result else { return }
            
            let bestString = result.bestTranscription.formattedString
            debugPrint(bestString)
        })
    }
    
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
