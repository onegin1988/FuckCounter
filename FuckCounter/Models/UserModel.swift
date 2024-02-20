//
//  UserModel.swift
//  FuckCounter
//
//  Created by Alex on 10.12.2023.
//

import Foundation

struct UserModel: Codable, Hashable {
    
    let id: String?
    let name: String?
    let image: String?
    let wins: Int
    let points: Int
    
    init(_ dict: [String: Any]) {
        self.id = dict["uid"] as? String
        self.name = dict["name"] as? String
        self.image = dict["image"] as? String
        self.wins = dict["wins"] as? Int ?? 0
        self.points = dict["points"] as? Int ?? 0
    }
    
    init(id: String = UUID().uuidString, 
         name: String? = nil,
         image: String? = nil,
         wins: Int = 0,
         points: Int = 0) {
        self.id = id
        self.name = name
        self.image = image
        self.wins = 0
        self.points = 0
    }
}
