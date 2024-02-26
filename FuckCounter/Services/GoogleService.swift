//
//  GoogleService.swift
//  FuckCounter
//
//  Created by Alex on 25.02.2024.
//

import FirebaseCore
import FirebaseAuth
import UIKit
import GoogleSignIn
import SwiftUI

class GoogleService: ObservableObject {
    
    @Published var isAuth = false
    @Published var error: String?
    @Published var userLoginModel: UserLoginModel?
    @Published var isAuthProcess = false
    
    init() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        self.isAuth = GIDSignIn.sharedInstance.hasPreviousSignIn()
        if self.isAuth {
            self.userLoginModel = AppData.userLoginModel
        }
    }
    
    @MainActor func checkIsNeedRefreshToken() async {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            Task {
                do {
                    let user = try await restorePreviousSignIn()
                    isAuth = user != nil
                    userLoginModel = await loadProfile()
                    userLoginModel?.providerId = Auth.auth().currentUser?.providerData.first?.providerID
                    AppData.userLoginModel = userLoginModel
                } catch let error {
                    self.error = error.localizedDescription
                    isAuth = false
                    AppData.userLoginModel = nil
                }
            }
        }
    }
    
    @MainActor func googleSignIn() async {
        do {
            isAuthProcess = true
            
            isAuth = try await authGoogle()
            userLoginModel = await loadProfile()
            userLoginModel?.providerId = Auth.auth().currentUser?.providerData.first?.providerID
            AppData.userLoginModel = userLoginModel
            
            isAuthProcess = false
        } catch let error {
            self.error = error.localizedDescription
            isAuth = false
            AppData.userLoginModel = nil
            isAuthProcess = false
        }
    }
    
    @MainActor func authGoogle() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.hasPreviousSignIn()
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { user, error in
                if let error = error {
                    if error.localizedDescription == "The user canceled the sign-in flow." {
                        continuation.resume(returning: false)
                    } else {
                        continuation.resume(throwing: error)
                    }
                    return
                }
                
                guard let authentication = user?.user, let idToken = authentication.idToken else { return }
                self.firebaseAuth(idToken, authentication) { errorAuth in
                    if let errorAuth = errorAuth {
                        continuation.resume(throwing: errorAuth)
                        return
                    }
                    
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    private func restorePreviousSignIn() async throws -> GIDGoogleUser? {
        return try await withCheckedThrowingContinuation({ continuation in
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: user)
            }
        })
    }
    
    private func loadProfile() async -> UserLoginModel {
        let user = GIDSignIn.sharedInstance.currentUser
        var url: URL?
        
        if user?.profile?.hasImage == true {
            url = user?.profile?.imageURL(withDimension: 100)
        }
        return UserLoginModel(id: user?.userID,
                              fistName: user?.profile?.familyName,
                              lastName: user?.profile?.givenName,
                              name: user?.profile?.name,
                              image: url?.absoluteString)
    }
    
    private func firebaseAuth(_ idToken: GIDToken, _ authentication: GIDGoogleUser, handler: @escaping (Error?) -> Void) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: authentication.accessToken.tokenString)
        Auth.auth().signIn(with: credential) { _, error in
            handler(error)
        }
    }
    
    @MainActor func googleSignOut() async {
        do {
            isAuthProcess = true
            GIDSignIn.sharedInstance.signOut()
            
            try Auth.auth().signOut()
            isAuth = false
            AppData.userLoginModel = nil
            
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
