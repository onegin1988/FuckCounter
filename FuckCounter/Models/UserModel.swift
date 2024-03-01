//
//  UserModel.swift
//  FuckCounter
//
//  Created by Alex on 10.12.2023.
//

import Foundation

struct UserModel: Codable {
    
    let id: String?
    let uid: String?
    let name: String?
    let image: String?
    let wins: Int
    let uuidDevice: String?
    var words: [WordModel]?
    var points: Int
    
    var reducePoints: Int {
        return (words ?? []).map({$0.countOfWords ?? 0}).reduce(0, { $0 + $1 })
    }
    
    init(_ dict: [String: Any]) {
        self.id = dict["id"] as? String ?? UUID().uuidString
        self.uid = dict["uid"] as? String ?? UUID().uuidString
        self.name = dict["name"] as? String
        self.image = dict["image"] as? String
        self.wins = dict["wins"] as? Int ?? 0
        self.uuidDevice = dict["uuidDevice"] as? String ?? UUID().uuidString
        self.points = dict["points"] as? Int ?? 0
        self.words = []
        
        if let wordsDict = dict["words"] as? [String: Any] {
            self.words = wordsDict.values.compactMap({WordModel($0 as? [String: Any])})
        }
    }
    
    init(id: String = UUID().uuidString,
         uid: String = UUID().uuidString,
         name: String? = nil,
         image: String? = nil,
         wins: Int = 0,
         points: Int = 0,
         uuidDevice: String = UUID().uuidString) {
        self.id = id
        self.uid = uid
        self.name = name
        self.image = image
        self.wins = 0
        self.uuidDevice = uuidDevice
        self.points = 0
        self.words = []
    }
}
