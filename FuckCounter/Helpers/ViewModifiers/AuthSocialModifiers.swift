//
//  AuthSocialModifiers.swift
//  FuckCounter
//
//  Created by Alex on 27.02.2024.
//

import SwiftUI

struct AuthSocialModifiers: ViewModifier {
    
    @EnvironmentObject var facebookService: FacebookService
    @EnvironmentObject var googleService: GoogleService
    @EnvironmentObject var appleService: AppleService
    
    private let authHandler: (Bool) -> Void
    
    init(authHandler: @escaping (Bool) -> Void) {
        self.authHandler = authHandler
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(facebookService.$isAuth, perform: { newValue in
                authHandler(newValue)
            })
            .onReceive(googleService.$isAuth, perform: { newValue in
                authHandler(newValue)
            })
            .onReceive(appleService.$isAuth, perform: { newValue in
                authHandler(newValue)
            })
    }
}

extension View {
    func authSocialModifiers(authHandler: @escaping (Bool) -> Void) -> some View {
        modifier(AuthSocialModifiers(authHandler: authHandler))
    }
}
