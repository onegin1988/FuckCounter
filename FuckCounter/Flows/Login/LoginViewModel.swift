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
    
    func appendUser(_ userLoginModel: UserLoginModel, _ user: User) async {
        do {
            var childValues: [String: Any] = [
                "uid": user.uid,
                "id": userLoginModel.id ?? "",
                "fistName": userLoginModel.fistName ?? "",
                "lastName": userLoginModel.lastName ?? "",
                "name": userLoginModel.name ?? "",
                "image": userLoginModel.image ?? "",
                "providerID": user.providerData.first?.providerID ?? ""
            ]
            
            let dataSnapshot = try await myCurrentUser(user)
            if dataSnapshot.exists() {
                childValues["updatedDate"] = Date().toString()
            } else {
                childValues["createdDate"] = Date().toString()
                childValues["updatedDate"] = Date().toString()
                childValues["wins"] = 0
            }
            try await reference.child(AppConstants.cUsers).child(user.uid).updateChildValues(childValues)
            
        } catch let error {
            self.error = error.localizedDescription
        }
    }
    
    func getAndAppendAppleUser(_ user: User) async {
        do {
            let value = try await myCurrentUser(user).value as? [String: Any]
            AppData.userLoginModel = UserLoginModel(dbDict: value)
        } catch let error {
            self.error = error.localizedDescription
        }
    }
    
    private func myCurrentUser(_ user: User) async throws -> DataSnapshot {
        return try await reference.child(AppConstants.cUsers).child(user.uid).getData()
    }

}
