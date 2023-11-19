//
//  GradientModifiers.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

struct GradientModifiers: ViewModifier {
    
    let style: GradientStyle.Style
    
    init(style: GradientStyle.Style) {
        self.style = style
    }
        
    func body(content: Content) -> some View {
        content
            .background {
                GradientStyle(style: style).gradient
            }
    }
}
