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

class GoogleService {
    
    @Published var error: String?
    
    init() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    
    func googleSignIn() {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.hasPreviousSignIn()
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { user, error in
            if let error = error {
                debugPrint("Error doing Google Sign-In, \(error)")
                self.error = error.localizedDescription
                return
            }
            
            guard
                let authentication = user?.user,
                let idToken = authentication.idToken
            else {
                print("Error during Google Sign-In authentication, \(String(describing: error))")
                self.error = error?.localizedDescription
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: authentication.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                }
                
                print("Signed in with Google")
            }
        }
    }
    
    func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
        print("Google sign out")
    }
}
