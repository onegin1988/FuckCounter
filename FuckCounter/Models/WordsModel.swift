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
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
