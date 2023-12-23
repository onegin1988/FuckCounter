//
//  ButtonView.swift
//  FuckCounter
//
//  Created by Alex on 23.12.2023.
//

import SwiftUI

struct ButtonView: View {
    
    private let title: String
    private let image: Image?
    private let useBG: Bool
    
    init(title: String, image: Image? = nil, useBG: Bool = true) {
        self.title = title
        self.image = image
        self.useBG = useBG
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: geometry.size.height/2)
                    .fill(useBG ? Colors._FFDD64 : .clear)
                
                HStack(spacing: 4) {
                    SemiboldTextView(style: .gilroy, title: title, size: 17, color: Colors._0A0A0A)
                    setupIconView()
                }
                .padding(EdgeInsets(top: 15, leading: 16, bottom: 15, trailing: 16))
            }
//            .background(
//                RoundedRectangle(cornerRadius: 2)
//                    .fill(useBG ? Colors._FFDD64 : .clear)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//            )
        })
    }
    
    @ViewBuilder private func setupIconView() -> some View {
        if let image = image {
            image
                .renderingMode(.template)
                .foregroundColor(Colors._0A0A0A)
                .frame(width: 24, height: 24)
                .scaledToFill()
        }
    }
}

#Preview {
    ButtonView(title: "Test", image: Images.checked)
}
