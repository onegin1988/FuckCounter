//
//  AlertModifiers.swift
//  FuckCounter
//
//  Created by Alex on 07.03.2024.
//

import SwiftUI

struct AlertModifiers: ViewModifier {
    
    @Binding private var showAlert: Bool
    private let title: String
    private let message: String
    private let cancelButton: (String, Bool, () -> Void)
    private let acceptButton: (String, Bool, () -> Void)
    
    init(showAlert: Binding<Bool>,
         title: String,
         message: String,
         cancelButton: (String, Bool, () -> Void) = ("Cancel", true, {}),
         acceptButton: (String, Bool, () -> Void) = ("Ok", false, {})) {
        self._showAlert = showAlert
        self.title = title
        self.message = message
        self.cancelButton = cancelButton
        self.acceptButton = acceptButton
    }
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $showAlert, actions: {
                if cancelButton.1 {
                    Button(cancelButton.0, role: .cancel, action: cancelButton.2)
                } else {
                    Button(cancelButton.0, action: cancelButton.2)
                }
                
                if acceptButton.1 {
                    Button(acceptButton.0, role: .destructive, action: acceptButton.2)
                } else {
                    Button(acceptButton.0, action: acceptButton.2)
                }
            }, message: {
                Text(message)
            })
    }
}

extension View {
    func customAlert(showAlert: Binding<Bool>,
                     title: String,
                     message: String,
                     cancelButton: (String, Bool, () -> Void) = ("Cancel", true, {}),
                     acceptButton: (String, Bool, () -> Void) = ("Ok", false, {})) -> some View {
        return modifier(AlertModifiers(
            showAlert: showAlert,
            title: title,
            message: message,
            cancelButton: cancelButton,
            acceptButton: acceptButton)
        )
    }
}
