//
//  LanguageModel.swift
//  FuckCounter
//
//  Created by Alex on 20.01.2024.
//

import Foundation

struct LanguageModel: Codable {
    
    let id: Int
    let name: String
    let languageCode: String
    
    init(id: Int, name: String, languageCode: String) {
        self.id = id
        self.name = name
        self.languageCode = languageCode
    }
}
