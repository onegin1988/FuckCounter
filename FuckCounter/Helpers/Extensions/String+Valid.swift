//
//  String+Valid.swift
//  FuckCounter
//
//  Created by Alex on 04.03.2024.
//

import Foundation
import NaturalLanguage

extension String {
    func isEmptyOrWhitespace() -> Bool {
        if isEmpty {
            return true
        }
        
        return trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
    
    func detectedLanguage(_ currentCode: String) -> Bool {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(self)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return false }
        return languageCode == currentCode
    }
}
