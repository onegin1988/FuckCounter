//
//  FacebookLoginModel.swift
//  FuckCounter
//
//  Created by Alex on 01.02.2024.
//

import Foundation

struct FacebookLoginModel: Codable {
    
    var id: String?
    var fistName: String?
    var lastName: String?
    var name: String?
    var image: String?
    
    init(_ dict: [String: Any]?) {
        self.id = dict?["id"] as? String ?? UUID().uuidString
        self.fistName = dict?["first_name"] as? String
        self.lastName = dict?["last_name"] as? String
        self.name = dict?["name"] as? String
        
        if let dictPicture = dict?["picture"] as? [String: Any], 
            let dictData = dictPicture["data"] as? [String: Any] {
            self.image = dictData["url"] as? String
        }
    }
}
