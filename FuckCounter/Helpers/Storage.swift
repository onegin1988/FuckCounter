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
    
}
