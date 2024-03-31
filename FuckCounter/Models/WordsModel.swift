//
//  WordsModel.swift
//  FuckCounter
//
//  Created by Alex on 08.12.2023.
//

import Foundation

struct FullWordsModel: Codable {
    
    let localize: String?
    let words: [WordsModel]?
}

struct WordsModel: Codable {
    
    let id: Int
    let name: String
    let nameCorrect: String
    let answer: [String]?
    
    init(id: Int, name: String, nameCorrect: String, answer: [String]?) {
        self.id = id
        self.name = name
        self.nameCorrect = nameCorrect
        self.answer = answer
    }
}
