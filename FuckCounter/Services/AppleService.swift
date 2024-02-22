//
//  AppleService.swift
//  FuckCounter
//
//  Created by Alex on 22.02.2024.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import Foundation

class AppleService: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    
    @Published var signedIn: Bool = false
    @Published var error: String?
    
    // Unhashed nonce.
    var currentNonce: String?
    
    override init() {
        super.init()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.signedIn = true
                print("Auth state changed, is signed in")
            } else {
                self.signedIn = false
                print("Auth state changed, is signed out")
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        
        return hashString
    }
    
    func startSignInWithAppleFlow() {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                self.error = "Invalid state: A login callback was received, but no login request was sent."
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                self.error = "Unable to fetch identity token."
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                self.error = "Unable to serialize token string from data: \(appleIDToken.debugDescription)"
                return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    self.error = error.localizedDescription
                    return
                }
                
                print("Apple sign in!")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        self.error = error.localizedDescription
        print("Sign in with Apple errored: \(error)")
    }
}
