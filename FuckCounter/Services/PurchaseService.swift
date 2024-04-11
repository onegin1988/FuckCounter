//
//  PurchaseService.swift
//  FuckCounter
//
//  Created by Alex on 15.03.2024.
//

import Foundation
import StoreKit

@MainActor
class PurchaseService: NSObject, ObservableObject {
    
    private let productIds = ProductType.allCases.map({$0.rawValue})// ["premium.one.month", "premium.one.week", "premium.three.month", "premium.one.year"]
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published private(set) var productForSettings: Product?
    @Published private(set) var isProcess: Bool = false
    
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
        
        updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        updates?.cancel()
    }
    
    // MARK: - Private
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
    
    // MARK: - Public
    
    func getProduct(id: String) -> Product? {
        return products.first(where: {$0.id == id})
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { 
            return
        }
        
        self.products = try await Product.products(for: productIds)
        self.productForSettings = getProduct(id: ProductType.oneWeek.rawValue)
        self.productsLoaded = true
    }
    
    @MainActor
    func purchase(_ product: Product) async throws {
        isProcess = true
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
            
            isProcess = false
        case let .success(.unverified(_, error)):
            debugPrint(error.localizedDescription)
            isProcess = false
        case .pending:
            isProcess = false
        case .userCancelled:
            isProcess = false
        @unknown default:
            break
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
        
        AppData.hasPremium = !purchasedProductIDs.isEmpty
    }
    
    func restore() async throws {
        try await AppStore.sync()
    }
}
 
// MARK: - SKPaymentTransactionObserver

extension PurchaseService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}
