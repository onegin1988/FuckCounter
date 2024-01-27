//
//  LeadersViewModel.swift
//  FuckCounter
//
//  Created by Alex on 10.12.2023.
//

import Foundation

class LeadersViewModel: ObservableObject {
    
    @Published var leadersTimeType: LeadersTimeType
    @Published var users: [UserModel]
    @Published var isAuthenticated: Bool
    @Published var leadersEvent: LeadersEvent?
    
    init() {
        self.leadersTimeType = .daily
        self.users = []
        self.isAuthenticated = AppData.isAuthenticated
        
//        var items = [
//            UserModel(id: 1, name: "Vicky Lanira Austen", winCount: 2, points: 2.09),
//            UserModel(id: 2, name: "Vicky Lanira Austen", winCount: 6, points: 3.08),
//            UserModel(id: 3, name: "Vicky Lanira Austen", winCount: 12, points: 7.08),
//            UserModel(id: 4, name: "Vicky Lanira Austen", winCount: 4, points: 2.89)
//        ]
//        
//        items.sort(by: {$0.winCount > $1.winCount})
//        self.users = items
    }
}
