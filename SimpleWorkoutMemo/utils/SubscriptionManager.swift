import StoreKit
import SwiftUI

enum SubscriptionStatus {
    // トライアル中
    case trial
    // 自動更新ありで契約中
    case active
    // 自動更新オフだがまだ期限内
    case inGracePeriod
    // 期限切れ（解約済み）
    case expired
    // 未購入
    case notPurchased
}

/// Subscription-related errors
enum SubscriptionError: LocalizedError {
    case purchaseFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .purchaseFailed:
            return "購入に失敗しました。もう一度お試しください。"
        case .unknown:
            return "不明なエラーが発生しました。"
        }
    }
}

/// Available subscription plans limited to Monthly and Yearly
enum SubscriptionPlan: String, CaseIterable, Equatable, Identifiable {
    case monthly
    case yearly
    
    var id: String {
        rawValue
    }
    
    var productID: String {
        switch self {
        case .monthly:
            return "SimpleWorkoutMemoMonthlyPlan"
        case .yearly:
            return "SimpleWorkoutMemoYearyPlan"
        }
    }
}

@MainActor
final class SubscriptionManager: ObservableObject {
    
    static let shared = SubscriptionManager()
    public init() {}
    
    @Published var isSubscribed: Bool = false
    @Published var products: [Product] = []
    @Published var selectedProduct: Product?
    @Published var currentProductID: String?
    @Published var subscriptionStatus: SubscriptionStatus?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Supported plans
    let supportedPlans: [SubscriptionPlan] = SubscriptionPlan.allCases
    
    // Derived product identifiers from supported plans
    var subscriptionProductIDs: [String] { supportedPlans.map { $0.productID } }
    
    func selectedProduct(for productId: String?) {
        guard let productId else {
            return
        }
         selectedProduct = products.first { product in
            product.id == productId
        }
    }
    
    func currentSubscribedProductID() async {
        for product in products {
            if let result = await Transaction.latest(for: product.id) {
                switch result {
                case .verified(let transaction):
                    // 失効していないかチェック
                    if transaction.revocationDate == nil,
                       transaction.expirationDate.map({ $0 > Date() }) ?? true {
                        currentProductID = product.id
                    }
                case .unverified:
                    continue
                }
            }
        }
    }
    
    /// Loads subscription products from the App Store.
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let products = try await Product.products(for: subscriptionProductIDs)
            self.products = products.sorted(by: { lhsproduct, rhsProduct in
                lhsproduct.id < rhsProduct.id
            })
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Updates the subscription status by checking current entitlements.
    func updateSubscriptionStatus() async {
        do {
            for await verificationResult in Transaction.currentEntitlements {
                switch verificationResult {
                case .verified(let transaction):
                    if subscriptionProductIDs.contains(transaction.productID) {
                        // Check if transaction is not revoked or expired
                        if transaction.revocationDate == nil,
                           transaction.expirationDate == nil || transaction.expirationDate! > Date() {
                            isSubscribed = true
                            return
                        }
                    }
                case .unverified:
                    continue
                }
            }
            isSubscribed = false
        } catch {
            errorMessage = error.localizedDescription
            isSubscribed = false
        }
    }
    
    /// Initiates purchase for the given product.
    /// - Parameter product: The subscription product to purchase.
    func purchase(_ product: Product) async {
        errorMessage = nil
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verificationResult):
                switch verificationResult {
                case .verified(let transaction):
                    await transaction.finish()
                    await updateSubscriptionStatus()
                case .unverified:
                    errorMessage = SubscriptionError.purchaseFailed.errorDescription
                }
            case .userCancelled:
                // User cancelled is non-fatal, no error message needed
                break
            case .pending:
                // Pending transactions do not change subscription state immediately
                break
            @unknown default:
                errorMessage = SubscriptionError.unknown.errorDescription
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// 復元（App Store と同期してから状態更新）
    func restorePurchases() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            // 1) App Store と購入情報を同期
            try await AppStore.sync()
            // 2) 同期後に現在の購読状態を更新
            await updateSubscriptionStatus()
            // 3) 必要なら現在のプランIDも更新
            await currentSubscribedProductID()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Sorted products by ascending price.
    var sortedProducts: [Product] {
        products.sorted { $0.price < $1.price }
    }
    
    /// Returns a formatted price string for a product including subscription period.
    /// - Parameter product: The product to format the price string for.
    /// - Returns: A string describing the subscription period and price, e.g., "Monthly – $4.99".
    func priceString(for product: Product) -> String {
        guard let subscription = product.subscription else {
            return product.displayPrice
        }
        
        let periodString: String
        switch subscription.subscriptionPeriod.unit {
        case .day:
            periodString = subscription.subscriptionPeriod.value == 1 ? "Daily" : "\(subscription.subscriptionPeriod.value) Days"
        case .week:
            periodString = subscription.subscriptionPeriod.value == 1 ? "Weekly" : "\(subscription.subscriptionPeriod.value) Weeks"
        case .month:
            periodString = subscription.subscriptionPeriod.value == 1 ? "Monthly" : "\(subscription.subscriptionPeriod.value) Months"
        case .year:
            periodString = subscription.subscriptionPeriod.value == 1 ? "Yearly" : "\(subscription.subscriptionPeriod.value) Years"
        @unknown default:
            periodString = "Subscription"
        }
        
        return "\(periodString) – \(product.displayPrice)"
    }
    
    /// Starts listening for transaction updates from the App Store.
    /// Call this once at app launch to avoid missing successful purchases delivered later.
    func startListeningForTransactions() {
        Task.detached { [weak self] in
            guard let self else { return }
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    // Only handle our subscription products
                    if await self.subscriptionProductIDs.contains(transaction.productID) {
                        await transaction.finish()
                        await self.updateSubscriptionStatus()
                    }
                case .unverified:
                    // Ignore or log if needed
                    continue
                }
            }
        }
    }
    
    func checkSubscriptionStatus() async {
        for product in products {
            guard let subscription = product.subscription else {
                continue
            }
            let statuses = try? await subscription.status
            guard let status = statuses?.first else {
                continue
            }
            
            let transactionResult = status.transaction
            let renewalInfoResult = status.renewalInfo
            
            switch transactionResult {
            case .verified(let transaction):
                // 解約済み
                guard let expirationDate = transaction.expirationDate else {
                    subscriptionStatus = .notPurchased
                    return
                }
                // 有効期限切れ
                if expirationDate <= Date() {
                    subscriptionStatus = .expired
                    return
                }
                // 自動更新オフ判定
                if case .verified(let renewalInfo)  = renewalInfoResult, renewalInfo.willAutoRenew == false {
                    subscriptionStatus = .inGracePeriod
                    return
                }
                // トライアル判定
                if transaction.offer?.type == .introductory {
                    subscriptionStatus = .trial
                    return
                }
                
                // ここま処理が通れば契約中
                subscriptionStatus = .active
            case .unverified(_, _):
                break
            }
            
            subscriptionStatus = .notPurchased
        }
    }
}
