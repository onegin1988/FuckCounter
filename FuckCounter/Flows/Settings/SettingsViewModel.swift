//
//  SettingsViewModel.swift
//  FuckCounter
//
//  Created by Alex on 10.12.2023.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class SettingsViewModel: ObservableObject {
    
//    @Published var apps: [AppsModel]
    @Published var isNotify: Bool
    @Published var showSheet: Bool
    @Published private(set) var settingsItems: [SettingsItem]
    @Published var error: String?
    @Published var settingsEvent: SettingsEvent?
    
    private let reference = Database.database().reference()
    
    init() {
        self.isNotify = true
        self.showSheet = false
        self.settingsItems = []
        
//        self.apps = [
////            AppsModel(name: "Sleeplover", description: "Reduse stress and fall asleep fast", imageName: "sleeploverIcon", url: "itms-apps://itunes.apple.com/app/id6466431666"),
//            AppsModel(name: "Sleeplover", description: "Reduse stress and fall asleep fast", imageName: "sleeploverIcon", url: "/itunes.apple.com/app/id6466431666"),
//            AppsModel(name: "Yoga 88", description: "Learn your body and relax your mind", imageName: "yoga88Icon", url: "itms-apps://itunes.apple.com/app/id")
//        ]
    }
    
    func updateSettingsItems(_ isAuthenticated: Bool) {
        if isAuthenticated {
            settingsItems = SettingsItem.allCases
        } else {
            settingsItems = SettingsItem.allCases.filter({ $0 != .deleteAccount && $0 != .logout })
        }
    }
    
    @MainActor
    func deleteAccount() async {
        do {
            guard let user = Auth.auth().currentUser else { return }
            try await reference.child("users").child(user.uid).removeValue()
            try await user.delete()
        } catch let error {
            self.error = error.localizedDescription
        }
    }
}
