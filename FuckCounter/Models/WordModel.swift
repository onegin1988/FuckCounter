//
//  WordModel.swift
//  FuckCounter
//
//  Created by Alex on 29.02.2024.
//

import Foundation

struct WordModel: Codable {
    
    let id: String?
    let countOfWords: Int?
    let createdDate: String?
    
    init(_ dict: [String: Any]?) {
        self.id = dict?["id"] as? String ?? UUID().uuidString
        self.countOfWords = dict?["countOfWords"] as? Int ?? 0
        self.createdDate = dict?["createdDate"] as? String ?? Date().toString()
    }
    
    init(id: String? = UUID().uuidString,
         countOfWords: Int? = 0,
         createdDate: String? = Date().toString()) {
        self.id = id
        self.countOfWords = countOfWords
        self.createdDate = createdDate
    }
}
