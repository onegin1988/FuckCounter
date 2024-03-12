//
//  String+Valid.swift
//  FuckCounter
//
//  Created by Alex on 04.03.2024.
//

import Foundation
//import NaturalLanguage
//import LanguageDetector

extension String {
    func isEmptyOrWhitespace() -> Bool {
        if isEmpty {
            return true
        }
        
        return trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
    
    func detectedLanguage(_ currentCode: String) -> Bool {
        return true
//        do {
//            let detector = try LanguageDetector(languages: LanguageCode.allCases.map({$0.rawValue}))
//            let result = try detector.evaluate(text: self)
//            return result?.first?.0 ?? "" == currentCode
//        } catch let error {
//            debugPrint(error.localizedDescription)
//            return false
//        }
    }
}
