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
    @Published var facebookLoginModel = FacebookLoginModel()
    @Published var isAuthenticating = false
    @Published var isAuth = false
    @Published var error = ""
    
    func logIn(){
        self.isAuth = false
        self.isAuthenticating = true
        
        facebookLoginManager.logIn(permissions: ["public_profile", "email", "user_friends"], from: nil) { loginResult, error in
            if let error = error {
                self.isAuthenticating = false
                self.error = error.localizedDescription
                return
            }
            
            print("DEBUG: Logged in! \(String(describing: loginResult?.grantedPermissions)) \(String(describing: loginResult?.declinedPermissions)) \(String(describing: loginResult?.token))")
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, email"]).start { connection, result, error in
                if let error = error {
                    self.isAuthenticating = false
                    self.error = error.localizedDescription
                    return
                }
                
                if let fbProfileDetails = result as? NSDictionary {
                    print("DEBUG: FB details \(fbProfileDetails)")
                    
                    self.isAuthenticating = false
                    self.isAuth = true
                    self.facebookLoginModel.email = fbProfileDetails.value(forKey: "email") as? String ?? ""
                    self.facebookLoginModel.id = fbProfileDetails.value(forKey: "id") as? String ?? UUID().uuidString
                    self.facebookLoginModel.name = fbProfileDetails.value(forKey: "name") as? String ?? ""
                    
                    if let token = AccessToken.current, !token.isExpired {
                        print("DEBUG: Token=\(token.tokenString)")
                    }
                }
            }
        }
    }
    
    func logOut(){
        self.facebookLoginModel.email = ""
        self.facebookLoginModel.id = ""
        self.facebookLoginModel.name = ""
        self.isAuth = false
    }
}
