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
    
    init(style: FontStyle, title: String, size: CGFloat = 14) {
        self.style = style
        self.title = title
        self.size = size
    }
    
    var body: some View {
        Text(title)
            .font(style.bold(size: size))
            .foregroundStyle(.white)
    }
}

#Preview {
    BoldTextView(style: .sfPro, title: "Test")
}
