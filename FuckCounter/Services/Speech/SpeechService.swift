//
//  SpeechService.swift
//  FuckCounter
//
//  Created by Alex on 15.12.2023.
//

import Foundation
import Speech
import SwiftUI
import Combine

class SpeechService: ObservableObject {
    
    @Published var speechRecognitionStatus: SpeechRecognitionStatus
    @Published var error: String?
    @Published var fullText: String?
    private var texts: [String]
    
    var engine: SpeechRecognitionEngine = SpeechRecognitionSpeechEngine()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        self.speechRecognitionStatus = .notStarted
        self.texts = []
    }
    
    func updateSpeechLocale() {
        engine = SpeechRecognitionSpeechEngine()
    }
    
    func requestSpeechAuthorization(handler: ((SFSpeechRecognizerAuthorizationStatus) -> Void)?) {
        engine.requestAuthorization()
        
        engine.authorizationStatusPublisher
            .sink { status in
                guard let status = status else { return }
                handler?(status)
            }.store(in: &cancellables)
    }
    
    func startRecording() {
        
        do {
            try engine.startRecording()
            
            engine.newUtterancePublisher
                .sink { newUtterance in
                    debugPrint(newUtterance)
                    if self.texts.isEmpty {
                        self.texts.append(newUtterance)
                    } else {
                        self.texts[self.texts.count - 1] = newUtterance
                    }
                    
                    self.fullText = self.texts.joined(separator: ". ")
                }.store(in: &cancellables)
            
            engine.recognitionStatusPublisher
                .sink { recognitionStatus in
                    self.speechRecognitionStatus = recognitionStatus
                    if recognitionStatus == .stopped {
                        self.texts.removeAll()
                        self.fullText = nil
                    } else if recognitionStatus == .waiting {
                        self.texts.append("")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.startRecording()
                        }
                    }
                }
                .store(in: &cancellables)
            
        } catch let error {
            self.error = error.localizedDescription
            engine.stopRecording()
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
        engine.stopRecording()
    }
    
    func pauseRecording() {
        do {
            try engine.pauseRecording()
        } catch let error {
            self.error = error.localizedDescription
        }
    }
    
    func resumeRecording() {
        do {
            try engine.resumeRecording()
        } catch let error {
            self.error = error.localizedDescription
        }
    }
}
