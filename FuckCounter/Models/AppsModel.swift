//
//  AppsModel.swift
//  FuckCounter
//
//  Created by Alex on 10.12.2023.
//

import Foundation

struct AppsModel: Codable {
    
    var id: String
    let name: String
    let description: String
    let imageName: String
    let url: String
    
    init(name: String, description: String, imageName: String, url: String) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.imageName = imageName
        self.url = url
    }
}
