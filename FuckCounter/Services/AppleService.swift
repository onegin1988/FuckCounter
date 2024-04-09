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
    
    @Published var isAuth: Bool = false
    @Published var error: String?
    @Published var userLoginModel: UserLoginModel?
    @Published var isAuthProcess = false
    @Published var isFinished = false
    
    // Unhashed nonce.
    var currentNonce: String?
        
    @MainActor func checkIsNeedRefresh() async {
        if !AppData.appleUserId.isEmpty {
            do {
                self.isAuth = try await getCredentialState()
                if isAuth {
                    self.userLoginModel = AppData.userLoginModel
                }
            } catch let error {
                self.error = error.localizedDescription
            }
        }
    }
    
    private func getCredentialState() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: AppData.appleUserId) { state, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: state == .authorized)
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
    
    @MainActor func startSignInWithAppleFlow() async {
        
        isAuthProcess = true
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
    
    @MainActor func signOut() async {
        do {
            isAuthProcess = true
            
            try Auth.auth().signOut()
            isAuth = false
            isFinished = false
            AppData.appleUserId = ""
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
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            isFinished = false
            firebaseLogin(credential: appleIdCredential)
        default:
            isAuthProcess = false
        }
    }
    
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        if let fullName = credential.fullName, fullName.givenName != nil {
            userLoginModel = UserLoginModel(id: credential.user,
                                     fistName: fullName.givenName,
                                     lastName: fullName.familyName,
                                     name: "\(fullName.givenName ?? "") \(fullName.familyName ?? "")",
                                     providerId: "apple.com")
            AppData.userLoginModel = userLoginModel
        } else {
            userLoginModel = nil
        }
    }
    
    func firebaseLogin(credential: ASAuthorizationAppleIDCredential) {
        guard let nonce = currentNonce else {
            self.error = "Invalid state: A login callback was received, but no login request was sent."
            isAuthProcess = false
            return
        }
        guard let appleIDToken = credential.identityToken else {
            self.error = "Unable to fetch identity token."
            isAuthProcess = false
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            self.error = "Unable to serialize token string from data: \(appleIDToken.debugDescription)"
            isAuthProcess = false
            return
        }
        
        AppData.appleUserId = credential.user
        let oauthCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        Auth.auth().signIn(with: oauthCredential) { (authResult, error) in
            if let error = error {
                self.error = error.localizedDescription
                self.isAuthProcess = false
                return
            }
            
            self.registerNewAccount(credential: credential)
            self.isAuthProcess = false
            self.isFinished = true
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if (error as? NSError)?.code != 1001 {
            self.error = error.localizedDescription
        }
        isAuthProcess = false
    }
}
