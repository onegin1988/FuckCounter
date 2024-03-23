//
//  SubscriptionView.swift
//  FuckCounter
//
//  Created by Alex on 17.03.2024.
//

import SwiftUI

struct SubscriptionView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    @EnvironmentObject var purchaseService: PurchaseService
    
    @State private var currentPage: Int = 0
    @State private var minSide = 0.0
    @State private var productType: ProductType = .oneMonth
    @State private var error: String?
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometryProxy in
                ZStack {
                    VStack(spacing: 0) {
                        setupScrollInfoView()
                        setupPageControlView()
                        setupProductTypeListView()
                            .padding(EdgeInsets(top: 54, leading: 0, bottom: 32, trailing: 0))
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
                .alertError(errorMessage: $error)
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
    private func setupProductTypeListView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem()], alignment: .center, spacing: 8, pinnedViews: [], content: {
                ForEach(ProductType.allCases, id: \.self) { productType in
                    let product = purchaseService.products.first(where: {$0.id == productType.rawValue})
                    SubscriptionTypeView(
                        isSelected: self.productType.rawValue == product?.id,
                        title: "\(productType.qty)",
                        weekDay: productType.weekDay,
                        price: product?.displayPrice ?? "",
                        percentage: productType.percentage)
                    .onTapGesture {
                        self.productType = productType
                    }
                    .frame(width: minSide * 0.28, height: minSide * 0.49)
                    .padding(.leading, productType == .oneMonth ? 16 : 0)
                    .padding(.trailing, productType == .oneYear ? 16 : 0)
                }
            })
            .frame(height: minSide * 0.5)
        }
    }
    
    @ViewBuilder
    private func setupContinueButtonView() -> some View {
        ButtonView(title: "CONTINUE", textColor: .black) {
            purchaseProduct()
        }
        .padding(.horizontal, 24)
        .frame(height: 56)
    }
    
    @ViewBuilder
    private func setupDescriptionView() -> some View {
        RegularTextView(style: .sfPro, title: "Tap to Continue, you approve that invoice will be placed on your iTunes account and subscription will be automtically renewal after selected period of package until you decline on iTunes Store settings (it should be declined minimum 24 hours before ending current subscription) by clicking Continue you accept our Terms and Conditions", size: 13)
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .padding(EdgeInsets(top: 24, leading: 8, bottom: 30, trailing: 8))
    }
    
    @MainActor
    private func purchaseProduct() {
        Task {
            do {
                guard let product = purchaseService.products.first(where: {$0.id == productType.rawValue}) else { return }
                try await purchaseService.purchase(product)
                dismiss()
            } catch let error {
                debugPrint(error.localizedDescription)
                self.error = error.localizedDescription
            }
        }
    }
}

#Preview {
    SubscriptionView()
}
