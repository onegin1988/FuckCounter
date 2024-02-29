//
//  UserModel.swift
//  FuckCounter
//
//  Created by Alex on 10.12.2023.
//

import Foundation

struct UserModel: Codable {
    
    let id: String?
    let name: String?
    let image: String?
    let wins: Int
    var words: [WordModel]?
    var points: Int
    
    var reducePoints: Int {
        return (words ?? []).map({$0.countOfWords ?? 0}).reduce(0, { $0 + $1 })
    }
    
    init(_ dict: [String: Any]) {
        self.id = dict["uid"] as? String
        self.name = dict["name"] as? String
        self.image = dict["image"] as? String
        self.wins = dict["wins"] as? Int ?? 0
        self.points = dict["points"] as? Int ?? 0
        self.words = []
        
        if let wordsDict = dict["words"] as? [String: Any] {
            self.words = wordsDict.values.compactMap({WordModel($0 as? [String: Any])})
        }
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
        self.words = []
    }
}
