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
    private let buttonColorBG: Color
    private let textColor: Color
    private let onTap: (() -> Void)?
    
    init(title: String, 
         image: Image? = nil,
         useBG: Bool = true,
         buttonBG: Color = Colors._FFDD64,
         textColor: Color = Colors._0A0A0A,
         onTap: (() -> Void)? = nil) {
        self.title = title
        self.image = image
        self.useBG = useBG
        self.buttonColorBG = buttonBG
        self.textColor = textColor
        self.onTap = onTap
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: geometry.size.height/2)
                    .fill(useBG ? buttonColorBG : .clear)
                
                HStack(spacing: 4) {
                    SemiboldTextView(style: .gilroy, title: title, size: 17, color: textColor)
                    setupIconView()
                }
                .padding(EdgeInsets(top: 15, leading: 16, bottom: 15, trailing: 16))
            }
        })
        .onTapGesture {
            onTap?()
        }
    }
    
    @ViewBuilder private func setupIconView() -> some View {
        if let image = image {
            image
                .renderingMode(.template)
                .foregroundColor(textColor)
                .frame(width: 24, height: 24)
                .scaledToFill()
        }
    }
}

#Preview {
    ButtonView(title: "Test", image: Images.checked)
}
