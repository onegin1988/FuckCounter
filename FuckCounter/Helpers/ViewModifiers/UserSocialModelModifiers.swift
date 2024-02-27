//
//  UserSocialModelModifiers.swift
//  FuckCounter
//
//  Created by Alex on 26.02.2024.
//

import SwiftUI

struct UserSocialModelModifiers: ViewModifier {
    
    @EnvironmentObject var facebookService: FacebookService
    @EnvironmentObject var googleService: GoogleService
    @EnvironmentObject var appleService: AppleService
    
    private let modelHandler: (UserLoginModel?) -> Void
    
    init(modelHandler: @escaping (UserLoginModel?) -> Void) {
        self.modelHandler = modelHandler
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(facebookService.$userLoginModel, perform: { facebookLoginModel in
                modelHandler(facebookLoginModel)
            })
            .onReceive(googleService.$userLoginModel, perform: { googleLoginModel in
                modelHandler(googleLoginModel)
            })
            .onReceive(appleService.$userLoginModel, perform: { appleLoginModel in
                modelHandler(appleLoginModel)
            })
    }
}

extension View {
    func userSocialModelModifiers(modelHandler: @escaping (UserLoginModel?) -> Void) -> some View {
        modifier(UserSocialModelModifiers(modelHandler: modelHandler))
    }
}
