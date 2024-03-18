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
                    VStack {
                        setupScrollInfoView()
                        PageControlView(numberOfPages: SubscriptionInfo.allCases.count,
                                        currentPage: $currentPage)
                            .frame(height: 6)
                            .padding(.top, 16)
                        Rectangle()
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
}

#Preview {
    SubscriptionView()
}
