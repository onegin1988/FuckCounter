//
//  SemiboldTextView.swift
//  FuckCounter
//
//  Created by Alex on 07.12.2023.
//

import SwiftUI

struct SemiboldTextView: View {
    
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
            .font(style.semibold(size: size))
            .foregroundStyle(.white)
    }
}

#Preview {
    SemiboldTextView(style: .gilroy, title: "Test")
}
