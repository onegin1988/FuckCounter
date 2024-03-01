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
                "providerID": user.providerData.first?.providerID ?? "",
                "uuidDevice": AppData.uuidDevice
            ]
            
            let currentUser = try await myCurrentUser(user)
            if currentUser != nil {
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
            let currentUser = try await myCurrentUser(user)
            AppData.userLoginModel = currentUser
        } catch let error {
            self.error = error.localizedDescription
        }
    }
    
    private func myCurrentUser(_ user: User) async throws -> UserLoginModel? {
        let snapshot = try await reference.child(AppConstants.cUsers).getData()
        let user = ((snapshot.value as? [String: [String: Any]])?.values)?
            .compactMap({UserLoginModel(dbDict: $0)})
            .first(where: { $0.uid == user.uid })
        return user
    }
}
