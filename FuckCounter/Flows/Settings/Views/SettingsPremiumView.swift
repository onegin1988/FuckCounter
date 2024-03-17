//
//  SettingsPremiumView.swift
//  FuckCounter
//
//  Created by Alex on 17.03.2024.
//

import SwiftUI

struct SettingsPremiumView: View {
    
    private let price: String
    private let buttonAction: () -> Void
    
    init(price: String, buttonAction: @escaping () -> Void) {
        self.price = price
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        ZStack {
            BlackBgView()

            VStack(spacing: 0) {
                titleSettingsPremiumView()
                descriptionSettingsPremiumView()
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 18, trailing: 0))
                buttonSettingsPremiumView()
                    .frame(width: 196, height: 36)
            }
            .padding(.vertical, 16)
        }
        
    }
    
    @ViewBuilder
    func titleSettingsPremiumView() -> some View {
        HStack(alignment: .center, spacing: 8) {
            Images.crown_2
                .resizable()
                .frame(width: 24, height: 24)
            
            BoldTextView(style: .sfPro, title: "Premium", size: 19)
        }
    }
    
    @ViewBuilder
    func descriptionSettingsPremiumView() -> some View {
        RegularTextView(style: .sfPro, title: "Unlock All Words,\nFriends statistic etc", size: 13, color: .white.opacity(0.59))
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    func buttonSettingsPremiumView() -> some View {
        Button(action: {
            buttonAction()
        }, label: {
            ZStack {
                Colors._EDEDED
                MediumTextView(style: .sfPro, title: "Upgrade From \(price)", color: Colors._342342)
            }
            .cornerRadius(16)
        })
    }
}

#Preview {
    SettingsPremiumView(price: "$0.99", buttonAction: {})
}
