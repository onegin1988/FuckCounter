//
//  Storage.swift
//  FuckCounter
//
//  Created by Alex on 14.12.2023.
//

import KeychainSwift
import Foundation

// MARK: - Keychain
@propertyWrapper
struct KeychainStorage<T: Codable> {
    
    private let key: String
    private let defaultValue: T
    private let keychain: KeychainSwift
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        
        self.keychain = KeychainSwift()
        self.keychain.accessGroup = AppConstants.group
    }
    
    var wrappedValue: T {
        get {
            guard let data = keychain.getData(key) else {
                return defaultValue
            }
            
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                keychain.set(data, forKey: key, withAccess: .accessibleWhenUnlocked)
            } else {
                keychain.set("", forKey: key, withAccess: .accessibleWhenUnlocked)
            }
        }
    }

}

// MARK: - Storage
@propertyWrapper
struct Storage<T: Codable> {
    
    private let key: String
    private let defaultValue: T
    private let userDefaults = UserDefaults(suiteName: AppConstants.group)
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard let data = userDefaults?.object(forKey: key) as? Data else {
                return defaultValue
            }
            
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults?.set(data, forKey: key)
        }
    }
}

// MARK: - AppData
struct AppData {
    
    // MARK: - @KeychainStorage
    @KeychainStorage(key: "uuidDevice", defaultValue: "")
    static var uuidDevice: String
    
    // MARK: - @Storage
    @Storage(key: "lastVersionPromptedForReviewKey", defaultValue: (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String) ?? "")
    static var lastVersionPromptedForReviewKey: String
    
    @Storage(key: "dailyKey", defaultValue: nil)
    static var dailyKey: DailyModel?
    
    @Storage(key: "selectedWordsModel", defaultValue: 
                WordsModel(id: 1,
                           name: "fuck".localize(AppData.selectedLanguageModel.languageCode),
                           nameCorrect: "fuck_title".localize(AppData.selectedLanguageModel.languageCode), answer: [
                            "Fuck"
                           ])
    )
    static var selectedWordsModel: WordsModel
    
    @Storage(key: "customWord", defaultValue: "")
    static var customWord: String
        
    @Storage(key: "userLoginModel", defaultValue: nil)
    static var userLoginModel: UserLoginModel?
    
    @Storage(key: "selectedLanguageModel", defaultValue:
                LanguageModel(id: 1, name: LanguageCode.en.title, languageCode: LanguageCode.en.rawValue, languageSymbol: LanguageCode.en.languageSymbol)
    )
    static var selectedLanguageModel: LanguageModel
    
    @Storage(key: "appleUserId", defaultValue: "")
    static var appleUserId: String
    
    @Storage(key: "lastDate", defaultValue: Date())
    static var lastDate: Date
    
    @Storage(key: "isOlder", defaultValue: false)
    static var isOlder: Bool
    
    @Storage(key: "hasPremium", defaultValue: false)
    static var hasPremium: Bool
    
    @Storage(key: "lastCount", defaultValue: 0)
    static var lastCount: Int
    
    @Storage(key: "lastRate", defaultValue: 0)
    static var lastRate: Int
    
    static func checkLanguage() -> LanguageModel {
        switch Locale.preferredLanguages[0].prefix(2) {
        case "en": return LanguageModel(id: 1, name: LanguageCode.en.title, languageCode: LanguageCode.en.rawValue, languageSymbol: LanguageCode.en.languageSymbol)
        case "de": return LanguageModel(id: 2, name: LanguageCode.de.title, languageCode: LanguageCode.de.rawValue, languageSymbol: LanguageCode.de.languageSymbol)
        case "fr": return LanguageModel(id: 3, name: LanguageCode.fr.title, languageCode: LanguageCode.fr.rawValue, languageSymbol: LanguageCode.fr.languageSymbol)
        case "uk": return LanguageModel(id: 4, name: LanguageCode.uk.title, languageCode: LanguageCode.uk.rawValue, languageSymbol: LanguageCode.uk.languageSymbol)
        case "ru": return LanguageModel(id: 5, name: LanguageCode.ru.title, languageCode: LanguageCode.ru.rawValue, languageSymbol: LanguageCode.ru.languageSymbol)
        default: return LanguageModel(id: 1, name: LanguageCode.en.title, languageCode: LanguageCode.en.rawValue, languageSymbol: LanguageCode.en.languageSymbol)
        }
    }
}
