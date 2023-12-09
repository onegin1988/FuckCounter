//
//  RegularTextView.swift
//  FuckCounter
//
//  Created by Alex on 07.12.2023.
//

import SwiftUI

struct RegularTextView: View {
    
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
            .font(style.regular(size: size))
            .foregroundStyle(color)
    }
}

#Preview {
    RegularTextView(style: .gilroy, title: "Title")
}
