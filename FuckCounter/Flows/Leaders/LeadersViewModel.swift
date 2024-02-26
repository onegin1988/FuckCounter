//
//  LeadersViewModel.swift
//  FuckCounter
//
//  Created by Alex on 10.12.2023.
//

import SwiftUI
import Foundation
import FirebaseDatabase

class LeadersViewModel: ObservableObject {
    
    @Published var leadersTimeType: LeadersTimeType
    @Published var users: [UserModel]
    @Published var leadersEvent: LeadersEvent?
    @Published var showAddUserSheet: Bool
    @Published var isLoading: Bool
    @Published var error: String?
    
    private let reference = Database.database().reference()
    
    init() {
        self.leadersTimeType = .daily
        self.users = []
        self.showAddUserSheet = false
        self.isLoading = true
    }
        
    func subscribeObserveUsers() async {
        reference.child("users").observe(.childChanged) { [weak self] dataSnapshot in
            guard let dict = dataSnapshot.value as? [String: Any] else { return }
            self?.updateUser(dict)
        }
        reference.child("users").observe(.childRemoved) { _ in
            Task {
                await self.loadUsers()
            }
        }
    }
    
    @MainActor
    func loadUsers() async {
        do {
            let snapshot = try await reference.child("users").getData()
            self.users = ((snapshot.value as? [String: [String: Any]])?.values)?
                .compactMap({UserModel($0)}) ?? []
            
            users.sort(by: { $0.wins > $1.wins })
            self.isLoading = false
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func updateUser(_ dict: [String: Any]) {
        let user = UserModel(dict)
        if let index = users.firstIndex(where: {$0.id == user.id}) {
            self.users[index] = user
        } else {
            self.users.append(user)
        }
        
        self.users.sort(by: { $0.wins > $1.wins })
    }
}
