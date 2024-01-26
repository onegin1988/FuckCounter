//
//  Storage.swift
//  FuckCounter
//
//  Created by Alex on 14.12.2023.
//

import Foundation

// MARK: - Storage
@propertyWrapper
struct Storage<T: Codable> {
    
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                return defaultValue
            }
            
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

// MARK: - AppData
struct AppData {
    @Storage(key: "lastVersionPromptedForReviewKey", defaultValue: (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String) ?? "")
    static var lastVersionPromptedForReviewKey: String
    
    @Storage(key: "dailyKey", defaultValue: nil)
    static var dailyKey: DailyModel?
    
    @Storage(key: "selectedWordsModel", defaultValue: WordsModel(id: 1, name: "Fuck"))
    static var selectedWordsModel: WordsModel
    
    @Storage(key: "customWord", defaultValue: "")
    static var customWord: String
    
    @Storage(key: "isAuthenticated", defaultValue: false)
    static var isAuthenticated: Bool
    
    @Storage(key: "selectedLanguageModel", defaultValue: checkLanguage())
    static var selectedLanguageModel: LanguageModel
    
    static func checkLanguage() -> LanguageModel {
        switch Locale.preferredLanguages[0].prefix(2) {
        case "en": return LanguageModel(id: 1, name: "English", languageCode: "en")
        case "de": return LanguageModel(id: 2, name: "Deutch", languageCode: "de")
        case "fr": return LanguageModel(id: 3, name: "France", languageCode: "fr")
        case "uk": return LanguageModel(id: 4, name: "Ukrainian", languageCode: "uk")
        case "ru": return LanguageModel(id: 5, name: "Russian", languageCode: "ru")
        default: return LanguageModel(id: 1, name: "English", languageCode: "en")
        }
    }
}
