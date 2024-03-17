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
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometryProxy in
                ZStack {
                    VStack {
                        setupScrollInfoView()
                        Spacer()
                    }
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
        .padding()

    }
}

#Preview {
    SubscriptionView()
}
