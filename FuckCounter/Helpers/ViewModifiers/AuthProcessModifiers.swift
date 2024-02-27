//
//  AuthProcessModifiers.swift
//  FuckCounter
//
//  Created by Alex on 26.02.2024.
//

import SwiftUI

struct AuthProcessModifiers: ViewModifier {
    
    @EnvironmentObject var facebookService: FacebookService
    @EnvironmentObject var googleService: GoogleService
    @EnvironmentObject var appleService: AppleService
    
    @Binding var isAuthProcess: Bool
    
    func body(content: Content) -> some View {
        content
            .onReceive(facebookService.$isAuthProcess, perform: { isAuthProcess in
                self.isAuthProcess = isAuthProcess
            })
            .onReceive(googleService.$isAuthProcess, perform: { isAuthProcess in
                self.isAuthProcess = isAuthProcess
            })
            .onReceive(appleService.$isAuthProcess, perform: { isAuthProcess in
                self.isAuthProcess = isAuthProcess
            })
    }
}

extension View {
    func authProcess(_ isAuthProcess: Binding<Bool>) -> some View {
        modifier(AuthProcessModifiers(isAuthProcess: isAuthProcess))
    }
}
