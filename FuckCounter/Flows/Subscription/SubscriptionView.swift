//
//  SubscriptionView.swift
//  SwearCounter
//
//  Created by Alex on 17.03.2024.
//

import SwiftUI

struct SubscriptionView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    @EnvironmentObject var purchaseService: PurchaseService
    
    @State private var currentPage: Int = 0
    @State private var isDraging: Bool = false
    @State private var minSide = 0.0
    @State private var productType: ProductType = .oneMonth
    @State private var error: String?
    @State private var isSubscriptionProcess = false
    
    @State private var timer = Timer.publish(every: 10, on: .main, in: .common)
    private let subscriptionInfo: SubscriptionInfo
    
    init(subscriptionInfo: SubscriptionInfo = .firstInfo) {
        self.subscriptionInfo = subscriptionInfo
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    setupScrollInfoView()
                    setupPageControlView()
                    setupProductTypeListView()
                        .padding(EdgeInsets(top: 54, leading: 0, bottom: 14, trailing: 0))
                    setupDescriptionView()
                    setupRestoreButtonView()
                        .padding(.bottom, 16)
                    setupContinueButtonView()
                    Spacer()
                }
            }
            .onFirstAppear {
                loadProducts()
                _ = timer.connect()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    currentPage = SubscriptionInfo.allCases.firstIndex(of: subscriptionInfo) ?? 0
                }
            }
            .onAppear {
                minSide = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
            }
            .onDisappear {
                timer.connect().cancel()
            }
            .onReceive(timer, perform: { _ in
                if !isDraging {
                    if currentPage != SubscriptionInfo.allCases.count - 1 {
                        currentPage += 1
                    } else {
                        currentPage = 0
                    }
                }
            })
            .onChange(of: scenePhase, perform: { newValue in
                if newValue == .active {
                    timer = Timer.publish(every: 5, on: .main, in: .common)
                    _ = timer.connect()
                } else {
                    timer.connect().cancel()
                }
            })
            .onReceive(purchaseService.$isProcess, perform: { isProcess in
                self.isSubscriptionProcess = isProcess
            })
            .padding(.top, safeAreaInsets.top + 64)
            .toolbarBackground(.hidden, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .green))
            .modifier(NavBarModifiers(isCancel: true))
            .ignoresSafeArea()
            .alertError(errorMessage: $error)
            .showProgress(isLoading: isSubscriptionProcess)
        }
        .allowsHitTesting(!isSubscriptionProcess)
        
    }
    
    @MainActor
    private func loadProducts() {
        Task {
            do {
                try await purchaseService.loadProducts()
            } catch let error {
                self.error = error.localizedDescription
            }
        }
    }
    
    @ViewBuilder
    private func setupScrollInfoView() -> some View {
        CollectionViewWrapper(items: SubscriptionInfo.allCases,
                              currentPage: $currentPage,
                              isDraging: $isDraging) { info in
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
        if !purchaseService.products.isEmpty {
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
    }
    
    @ViewBuilder
    private func setupContinueButtonView() -> some View {
        let product = purchaseService.products.first(where: {$0.id == productType.rawValue})        
        ButtonView(title: "CONTINUE - \(product?.displayPrice ?? "") TOTAL", textColor: .black) {
            purchaseProduct()
        }
        .padding(.horizontal, 24)
        .frame(height: 56)
    }
    
    @ViewBuilder
    private func setupRestoreButtonView() -> some View {
        ButtonView(title: "RESTORE PURCHASE", useBG: false, textColor: .white) {
            Task {
                do {
                    try await purchaseService.restore()
                } catch let error {
                    self.error = error.localizedDescription
                }
            }
        }
        .padding(.horizontal, 24)
        .frame(height: 36)
    }
    
    @ViewBuilder
    private func setupDescriptionView() -> some View {
        Text(subscriptionText)
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .padding(EdgeInsets(top: 24, leading: 8, bottom: 14, trailing: 8))
    }
    
    private var subscriptionText: AttributedString {
        var attriString = AttributedString("Recurring billing. Cancel anytime. Payment will be charged to your iTunes account at confirmation of purchase. Your subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period. You can manage your subscription and switch off auto-renewal by accessing your iTunes & App Store Account Settings after purchase. More details can be found here:\nTerms and Conditions, Privacy policy")
        attriString.foregroundColor = .white
        attriString.font = .custom("SFProDisplay-Regular", size: 12)
        
        if let termsRange = attriString.range(of: "Terms and Conditions") {
            attriString[termsRange].link = URL(string: "https://swear-counter.my.canva.site")
            attriString[termsRange].underlineStyle = .single
        }
        
        if let policyRange = attriString.range(of: "Privacy policy") {
            attriString[policyRange].link = URL(string: "https://swear-counter.my.canva.site")
            attriString[policyRange].underlineStyle = .single
        }
        
        return attriString
    }
    
    @MainActor
    private func purchaseProduct() {
        Task {
            do {
                guard let product = purchaseService.products.first(where: {$0.id == productType.rawValue}) else { return }
                try await purchaseService.purchase(product)
                
                if !purchaseService.purchasedProductIDs.isEmpty {
                    dismiss()
                }
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
