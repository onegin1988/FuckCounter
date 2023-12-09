//
//  BoldTextView.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

struct BoldTextView: View {
    
    private let style: FontStyle
    private let title: String
    private let size: CGFloat
    private let color: Color
    
    init(style: FontStyle, title: String, size: CGFloat = 14, color: Color = .white) {
        self.style = style
        self.title = title
        self.size = size
        self.color = color
    }
    
    var body: some View {
        Text(title)
            .font(style.bold(size: size))
            .foregroundStyle(color)
    }
}

#Preview {
    BoldTextView(style: .sfPro, title: "Test")
}
