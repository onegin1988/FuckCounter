//
//  WordsModel.swift
//  FuckCounter
//
//  Created by Alex on 08.12.2023.
//

import Foundation

struct WordsModel: Codable {
    
    let id: Int
    let name: String
    let isCustom: Bool
    
    init(id: Int, name: String, isCustom: Bool = false) {
        self.id = id
        self.name = name
        self.isCustom = isCustom
    }
}
