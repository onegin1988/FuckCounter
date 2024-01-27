//
//  LeadersPlaceholderView.swift
//  FuckCounter
//
//  Created by Alex on 27.01.2024.
//

import SwiftUI

struct LeadersPlaceholderView: View {
    
    private let title: String
    private let actionTitle: String
    private let action: () -> Void
    
    init(title: String, actionTitle: String, action: @escaping () -> Void) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }
    
    struct LeadersPlaceholderConstants {
        static let imageSize: CGFloat = 72
        static let buttonHeight: CGFloat = 52
    }
    
    var body: some View {
        VStack {
            makeCupBigImage()
            makeTitleCupBigView()
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 24, trailing: 0))
            makeButtonCupBigView()
        }
    }
    
    @ViewBuilder
    private func makeCupBigImage() -> some View {
        Images.cupBig
            .resizable()
            .scaledToFit()
            .frame(width: LeadersPlaceholderConstants.imageSize,
                   height: LeadersPlaceholderConstants.imageSize)
    }
    
    @ViewBuilder
    private func makeTitleCupBigView() -> some View {
        MediumTextView(style: .sfPro, title: title, size: 13)
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private func makeButtonCupBigView() -> some View {
        ButtonView(title: actionTitle, useBG: true, buttonBG: Colors._FFDD64, textColor: .black) {
            action()
        }
        .frame(height: LeadersPlaceholderConstants.buttonHeight)
    }
}

#Preview {
    LeadersPlaceholderView(title: "Here you can see your friend’s\nstatistic. Add friends to see it", actionTitle: "Action", action: {})
        .background {
            Color.red
                .ignoresSafeArea()
        }
}
