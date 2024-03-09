//
//  ProgressModifiers.swift
//  FuckCounter
//
//  Created by Alex on 06.02.2024.
//

import SwiftUI

struct ProgressModifiers: ViewModifier {
    
    private let isLoading: Bool

    init(isLoading: Bool = false) {
        self.isLoading = isLoading
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea(.all)
                        
                        ProgressView()
                            .controlSize(.regular)
                            .tint(.white)
                            .offset(y: 32)
                    }
                    .transition(AnyTransition.opacity.animation(.default))
                }
            }
    }
}

extension View {
    func showProgress(isLoading: Bool = false) -> some View {
        modifier(ProgressModifiers(isLoading: isLoading))
    }
}
