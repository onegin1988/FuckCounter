//
//  FacebookService.swift
//  FuckCounter
//
//  Created by Alex on 01.02.2024.
//

import SwiftUI
import FacebookCore
import FacebookLogin

class FacebookService: ObservableObject {
        
    let facebookLoginManager = LoginManager()
    @Published var facebookLoginModel: FacebookLoginModel?
    @Published var isAuth = false
    @Published var error = ""
    
    init() {
        self.isAuth = AccessToken.isCurrentAccessTokenActive
        
        if self.isAuth {
            self.facebookLoginModel = AppData.facebookLoginModel
        } else {
            AppData.facebookLoginModel = nil
        }
    }
    
    @MainActor func logIn() async {
        do {
            if !isAuth {
                isAuth = try await authFb()
                facebookLoginModel = try await loadProfile()
                AppData.facebookLoginModel = facebookLoginModel
            } else {
                facebookLoginModel = try await loadProfile()
                AppData.facebookLoginModel = facebookLoginModel
            }
        } catch let error {
            isAuth = false
            self.error = error.localizedDescription
        }
    }
    
    private func authFb() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                self.facebookLoginManager.logIn(permissions: [.publicProfile], viewController: nil) { loginResult in
                    switch loginResult {
                    case .success:
                        continuation.resume(returning: true)
                    case .cancelled:
                        continuation.resume(returning: false)
                    case .failed(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func loadProfile() async throws -> FacebookLoginModel {
        return try await withCheckedThrowingContinuation { continuation in
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(square)"]).start { connection, result, error in
                if let err = error as? NSError {
                    continuation.resume(throwing: err)
                }
                
                continuation.resume(returning: FacebookLoginModel(result as? [String: Any]))
            }
        }
    }
    
    @MainActor func logOut() async {
        facebookLoginManager.logOut()
        
        AccessToken.current = nil
        Profile.current = nil
        AppData.facebookLoginModel = nil
        self.isAuth = false
        self.facebookLoginModel = nil
    }
}
