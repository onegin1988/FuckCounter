//
//  GradientModifiers.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

struct GradientModifiers: ViewModifier {
    
    let style: GradientStyle.Style
    let useBlackOpacity: Bool
    
    init(style: GradientStyle.Style, useBlackOpacity: Bool = false) {
        self.style = style
        self.useBlackOpacity = useBlackOpacity
    }
        
    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    GradientStyle(style: style).gradient
                    if useBlackOpacity {
                        Color.black.opacity(0.2)
                        Color.black.opacity(0.2)
                    }
                }
            }
    }
}
