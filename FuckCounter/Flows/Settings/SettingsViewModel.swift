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
            AppsModel(name: "Sleeplover", description: "Reduse stress and fall asleep fast", imageName: "sleeploverIcon"),
            AppsModel(name: "Yoga 88", description: "Learn your body and relax your mind", imageName: "yoga88Icon")
        ]
    }
}
