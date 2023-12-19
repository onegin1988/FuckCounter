//
//  SettingsViewModel.swift
//  FuckCounter
//
//  Created by Alex on 10.12.2023.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var apps: [AppsModel]
    @Published var isNotify: Bool
    @Published var showSheet: Bool
    
    init() {
        self.isNotify = true
        self.showSheet = false
        
        self.apps = [
//            AppsModel(name: "Sleeplover", description: "Reduse stress and fall asleep fast", imageName: "sleeploverIcon", url: "itms-apps://itunes.apple.com/app/id6466431666"),
            AppsModel(name: "Sleeplover", description: "Reduse stress and fall asleep fast", imageName: "sleeploverIcon", url: "/itunes.apple.com/app/id6466431666"),
            AppsModel(name: "Yoga 88", description: "Learn your body and relax your mind", imageName: "yoga88Icon", url: "itms-apps://itunes.apple.com/app/id")
        ]
    }
}
