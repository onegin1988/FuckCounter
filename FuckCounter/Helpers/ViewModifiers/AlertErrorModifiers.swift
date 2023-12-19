//
//  AlertErrorModifiers.swift
//  FuckCounter
//
//  Created by Alex on 18.12.2023.
//

import SwiftUI

struct AlertErrorModifiers: ViewModifier {
    
    @Binding var errorMessage: String?
    private let useButtons: (String, (() -> Void)?)?
    private var isShowingError: Binding<Bool> {
        Binding { errorMessage != nil } set: { _ in errorMessage = nil }
    }
    
    init(errorMessage: Binding<String?>, useButtons: (String, (() -> Void)?)? = nil) {
        self._errorMessage = errorMessage
        self.useButtons = useButtons
    }
    
    func body(content: Content) -> some View {
        return content
            .alert(isPresented: isShowingError, content: {
                if let useButtons = useButtons {
                    Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), primaryButton: .cancel(), secondaryButton: .default(Text(useButtons.0), action: {
                        useButtons.1?()
                    }))
                } else {
                    Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"))
                }
            })
    }
}

extension View {
    func alertError(errorMessage: Binding<String?>, useButtons: (String, (() -> Void)?)? = nil) -> some View {
        modifier(AlertErrorModifiers(errorMessage: errorMessage, useButtons: useButtons))
    }
}
