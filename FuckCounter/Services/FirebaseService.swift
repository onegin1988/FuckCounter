//
//  FirebaseService.swift
//  FuckCounter
//
//  Created by Alex on 09.02.2024.
//

import FirebaseAuth
import FirebaseDatabase
import SwiftUI

class FirebaseService: ObservableObject {
    
    let reference = Database.database().reference()
    
    @Published var error: String?
    
    func appendUser(_ facebookLoginModel: FacebookLoginModel, _ user: User) async throws {
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
        }
        
        try await reference.child("users").child(user.uid).updateChildValues(childValues)
    }
    
    func myCurrentUser(_ user: User) async throws -> DataSnapshot {
        return try await reference.child("users").child(user.uid).getData()
    }
    
    func getUser(_ uid: String) async throws -> DataSnapshot {
        return try await reference.child("users").child(uid).getData()
    }
    
    func observeUsersValue() {
        reference.child("users").observe(.value) { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    
                }
            }
        }
    }
}
