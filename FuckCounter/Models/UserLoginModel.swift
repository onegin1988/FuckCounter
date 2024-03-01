//
//  FacebookLoginModel.swift
//  FuckCounter
//
//  Created by Alex on 01.02.2024.
//

import Foundation

struct UserLoginModel: Codable {
    
    var id: String?
    var fistName: String?
    var lastName: String?
    var name: String?
    var image: String?
    var providerId: String?
    var uid: String?
    
    init(id: String? = UUID().uuidString,
         uid: String? = UUID().uuidString,
         fistName: String? = nil,
         lastName: String? = nil,
         name: String? = nil,
         image: String? = nil,
         providerId: String? = nil) {
        self.id = id
        self.uid = uid
        self.fistName = fistName
        self.lastName = lastName
        self.name = name
        self.image = image
        self.providerId = providerId
    }
    
    init(fbDict: [String: Any]?) {
        self.id = fbDict?["id"] as? String ?? UUID().uuidString
        self.fistName = fbDict?["first_name"] as? String
        self.lastName = fbDict?["last_name"] as? String
        self.name = fbDict?["name"] as? String
        
        if let dictPicture = fbDict?["picture"] as? [String: Any], 
            let dictData = dictPicture["data"] as? [String: Any] {
            self.image = dictData["url"] as? String
        }
    }
    
    init(dbDict: [String: Any]?) {
        self.id = dbDict?["id"] as? String ?? UUID().uuidString
        self.fistName = dbDict?["fistName"] as? String
        self.lastName = dbDict?["lastName"] as? String
        self.name = dbDict?["name"] as? String
        self.image = dbDict?["image"] as? String
        self.uid = dbDict?["uid"] as? String
        self.providerId = dbDict?["providerID"] as? String
    }
}
