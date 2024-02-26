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
    }
}

extension View {
    func userSocialModelModifiers(modelHandler: @escaping (UserLoginModel?) -> Void) -> some View {
        modifier(UserSocialModelModifiers(modelHandler: modelHandler))
    }
}
