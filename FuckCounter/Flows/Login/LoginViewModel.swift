//
//  LoginViewModel.swift
//  FuckCounter
//
//  Created by Alex on 16.02.2024.
//

import FirebaseAuth
import FirebaseDatabase
import Foundation

class LoginViewModel: ObservableObject {
    
    private let reference = Database.database().reference()
    
    @Published var error: String?
    
    func appendUser(_ facebookLoginModel: FacebookLoginModel, _ user: User) async {
        do {
            var childValues: [String: Any] = [
                "uid": user.uid,
                "facebookId": facebookLoginModel.id ?? "",
                "fistName": facebookLoginModel.fistName ?? "",
                "lastName": facebookLoginModel.lastName ?? "",
                "name": facebookLoginModel.name ?? "",
                "image": facebookLoginModel.image ?? ""
            ]
            
            let dataSnapshot = try await myCurrentUser(user)
            if dataSnapshot.exists() {
                childValues["updatedDate"] = Date().toString()
            } else {
                childValues["createdDate"] = Date().toString()
                childValues["updatedDate"] = Date().toString()
                childValues["wins"] = 0
            }
            try await reference.child("users").child(user.uid).updateChildValues(childValues)
            
        } catch let error {
            self.error = error.localizedDescription
        }
    }
    
    private func myCurrentUser(_ user: User) async throws -> DataSnapshot {
        return try await reference.child("users").child(user.uid).getData()
    }

}
