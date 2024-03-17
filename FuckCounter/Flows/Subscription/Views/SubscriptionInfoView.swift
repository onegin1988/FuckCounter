//
//  SubscriptionInfoView.swift
//  FuckCounter
//
//  Created by Alex on 17.03.2024.
//

import SwiftUI

struct SubscriptionInfoView: View {
    
    private let subscriptionInfo: SubscriptionInfo
    
    init(subscriptionInfo: SubscriptionInfo) {
        self.subscriptionInfo = subscriptionInfo
    }
    
    var body: some View {
        VStack(spacing: 16) {
            imageSubscriptionInfoView()
            
            VStack(spacing: 0) {
                titleSubscriptionInfoView()
                descriptionSubscriptionInfoView()
            }
        }
    }
    
    @ViewBuilder
    func imageSubscriptionInfoView() -> some View {
        Images.subscriptionBgIcon
            .resizable()
            .frame(width: 56, height: 56)
            .overlay {
                subscriptionInfo.info.2
                    .resizable()
                    .frame(width: 32, height: 32)
            }
    }
    
    @ViewBuilder
    func titleSubscriptionInfoView() -> some View {
        BoldTextView(style: .sfPro, title: subscriptionInfo.info.0, size: 23)
            .frame(height: 36)
    }
    
    @ViewBuilder
    func descriptionSubscriptionInfoView() -> some View {
        RegularTextView(style: .sfPro, title: subscriptionInfo.info.1, size: 13)
            .frame(height: 20)
    }
}

#Preview {
    SubscriptionInfoView(subscriptionInfo: .firstInfo)
        .background {
            Color.red
        }
}
