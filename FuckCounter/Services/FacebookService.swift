//
//  FacebookService.swift
//  FuckCounter
//
//  Created by Alex on 01.02.2024.
//

import SwiftUI
import FacebookCore
import FacebookLogin
import FirebaseAuth

class FacebookService: ObservableObject {
        
    let facebookLoginManager = LoginManager()
    @Published var userLoginModel: UserLoginModel?
    @Published var isAuth = false
    @Published var isAuthProcess = false
    @Published var error: String?
    
    init() {
        self.isAuth = AccessToken.isCurrentAccessTokenActive
        
        if self.isAuth {
            self.userLoginModel = AppData.userLoginModel
        }
    }
    
    @MainActor func checkIsNeedRefreshToken() async {
        if let isExpired = AccessToken.current?.isExpired, isExpired {
            do {
                
                try await AccessToken.refreshCurrentAccessToken()
                self.isAuth = AccessToken.isCurrentAccessTokenActive
                
                userLoginModel = try await loadProfile()
                userLoginModel?.providerId = Auth.auth().currentUser?.providerData.first?.providerID
                AppData.userLoginModel = userLoginModel
            } catch let error {
                self.error = error.localizedDescription
                self.isAuth = false
                AppData.userLoginModel = nil
            }
        }
    }
    
    @MainActor func logIn() async {
        do {
            if !isAuth {
                isAuthProcess = true
                
                isAuth = try await authFb()
                userLoginModel = try await loadProfile()
                userLoginModel?.providerId = Auth.auth().currentUser?.providerData.first?.providerID
                AppData.userLoginModel = userLoginModel
                
                isAuthProcess = false
            } else {
                isAuthProcess = true
                
                userLoginModel = try await loadProfile()
                userLoginModel?.providerId = Auth.auth().currentUser?.providerData.first?.providerID
                AppData.userLoginModel = userLoginModel
                
                isAuthProcess = false
            }
        } catch let error {
            isAuth = false
            isAuthProcess = false
            self.error = error.localizedDescription
        }
    }
    
    private func authFb() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                self.facebookLoginManager.logIn(permissions: [.publicProfile], viewController: nil) { loginResult in
                    switch loginResult {
                    case .success(_, _, let token):
                        if !token.isExpired {
                            self.firebaseAuth(token.tokenString) { errorAuth in
                                if let errorAuth = errorAuth {
                                    continuation.resume(throwing: errorAuth)
                                    return
                                }
                                continuation.resume(returning: true)
                            }
                        } else {
                            continuation.resume(returning: false)
                        }
                    case .cancelled:
                        continuation.resume(returning: false)
                    case .failed(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func firebaseAuth(_ accessToken: String, handler: @escaping (Error?) -> Void) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        
        Auth.auth().signIn(with: credential) { _, errorAuth in
            handler(errorAuth)
        }
    }
    
    private func loadProfile() async throws -> UserLoginModel {
        return try await withCheckedThrowingContinuation { continuation in
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(square)"]).start { connection, result, error in
                if let err = error as? NSError {
                    continuation.resume(throwing: err)
                    return
                }
                
                continuation.resume(returning: UserLoginModel(fbDict: result as? [String: Any]))
            }
        }
    }
    
    func getFriends() {
        GraphRequest(graphPath: "me/taggable_friends", parameters: ["fields": "id, first_name, last_name, middle_name, name, email, picture"]).start { connection, result, error in
            
        }
    }
    
    @MainActor func logOut() async {
        do {
            isAuthProcess = true
            
            facebookLoginManager.logOut()
            try Auth.auth().signOut()
            
            AccessToken.current = nil
            Profile.current = nil
            AppData.userLoginModel = nil
            self.isAuth = false
            self.userLoginModel = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isAuthProcess = false
            }
        } catch let error {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isAuthProcess = false
            }
            self.error = error.localizedDescription
        }
    }
}
