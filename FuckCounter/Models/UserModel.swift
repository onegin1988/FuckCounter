//
//  UserModel.swift
//  FuckCounter
//
//  Created by Alex on 10.12.2023.
//

import Foundation

struct UserModel: Codable {
    
    let id: Int
    let name: String
    let winCount: Int
    let points: Float
    
    init(id: Int, name: String, winCount: Int, points: Float) {
        self.id = id
        self.name = name
        self.winCount = winCount
        self.points = points
    }
}
