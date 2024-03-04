//
//  CustomWordViewModel.swift
//  FuckCounter
//
//  Created by Alex on 24.01.2024.
//

import SwiftUI

class CustomWordViewModel: ObservableObject {
    
    @Published var keyboardHeight: CGFloat
    @Published var textInput: String
    @Published var error: String?
    
    init() {
        self.keyboardHeight = 0
        self.textInput = ""
    }
}
