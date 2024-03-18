//
//  SubscriptionView.swift
//  FuckCounter
//
//  Created by Alex on 17.03.2024.
//

import SwiftUI

struct SubscriptionView: View {
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    @State private var currentPage: Int = 0
    @State private var minSide = 0.0
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometryProxy in
                ZStack {
                    VStack(spacing: 0) {
                        setupScrollInfoView()
                        setupPageControlView()
                        Rectangle()
                        setupContinueButtonView()
                        setupDescriptionView()
                    }
                }
                .onAppear {
                    minSide = min(geometryProxy.size.width, geometryProxy.size.height)
                }
                .padding(.top, safeAreaInsets.top + 64)
                .toolbarBackground(.hidden, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .modifier(GradientModifiers(style: .green))
                .modifier(NavBarModifiers())
                .ignoresSafeArea()
            }
        }
    }
    
    @ViewBuilder
    private func setupScrollInfoView() -> some View {
        CollectionViewWrapper(items: SubscriptionInfo.allCases, currentPage: $currentPage) { info in
            SubscriptionInfoView(subscriptionInfo: info)
        }
        .frame(height: minSide * 0.33)
    }
    
    @ViewBuilder
    private func setupPageControlView() -> some View {
        PageControlView(numberOfPages: SubscriptionInfo.allCases.count,
                        currentPage: $currentPage)
        .frame(height: 6)
        .padding(.top, 16)
    }
    
    @ViewBuilder
    private func setupContinueButtonView() -> some View {
        ButtonView(title: "CONTINUE", textColor: .black) {
            
        }
        .padding(.horizontal, 24)
        .frame(height: 56)
    }
    
    @ViewBuilder
    private func setupDescriptionView() -> some View {
        RegularTextView(style: .sfPro, title: "Tap to Continue, you approve that invoice will be placed on your iTunes account and subscription will be automtically renewal after selected period of package until you decline on iTunes Store settings (it should be declined minimum 24 hours before ending current subscription) by clicking Continue you accept our Terms and Conditions", size: 12)
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .padding(EdgeInsets(top: 24, leading: 8, bottom: 30, trailing: 8))
    }
}

#Preview {
    SubscriptionView()
}
