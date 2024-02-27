//
//  SocialServicesModifiers.swift
//  FuckCounter
//
//  Created by Alex on 26.02.2024.
//

import SwiftUI

struct ErrorSocialServicesModifiers: ViewModifier {
    
    @EnvironmentObject var facebookService: FacebookService
    @EnvironmentObject var googleService: GoogleService
    @EnvironmentObject var appleService: AppleService
    
    @Binding var error: String?
    
    func body(content: Content) -> some View {
        content
            .onReceive(facebookService.$error, perform: { error in
                self.error = error
            })
            .onReceive(googleService.$error, perform: { error in
                self.error = error
            })
            .onReceive(appleService.$error, perform: { error in
                self.error = error
            })
    }
}

extension View {
    func errorSocialServices(_ error: Binding<String?>) -> some View {
        modifier(ErrorSocialServicesModifiers(error: error))
    }
}
