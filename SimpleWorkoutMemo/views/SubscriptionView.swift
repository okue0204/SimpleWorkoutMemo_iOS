import SwiftUI
import StoreKit

private struct AlertItem: Identifiable {
    let id = UUID()
    let message: String
}

struct SubscriptionView: View {
    @EnvironmentObject var subscription: SubscriptionManager
    @State private var isPurchasing = false
    @State private var alertItem: AlertItem?
    @State private var scrollPosition: String?
    @State private var selectedProductId: String?
    @Environment(\.dismiss) private var dismiss
    
    private var displayWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.vertical) {
                    VStack {
                        HStack {
                            Text("プレミアムで機能を解放しよう！")
                                .foregroundStyle(.white)
                                .font(.medium(size: 22))
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        HStack {
                            Text("プラン選択")
                                .foregroundStyle(.white)
                                .font(.semiBold(size: 18))
                            Spacer()
                        }
                        .padding(.top, 12)
                        .padding(.leading, 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(subscription.products, id: \.id) { product in
                                    SubscriptionPlanItemView(
                                        selectedProductId: $selectedProductId,
                                        productId: product.id,
                                        name: product.displayName,
                                        price: product.displayPrice, plan: SubscriptionPlan.allCases.first(where: { plan in
                                            plan.productID == product.id
                                        })!)
                                    .environmentObject(SubscriptionManager.shared)
                                    .frame(width: displayWidth - 80, height: 160)
                                    .containerRelativeFrame(.horizontal, alignment: .leading)
                                    .padding(.leading, 12)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .safeAreaPadding(.trailing, 80)
                        .scrollTargetBehavior(.viewAligned)
                        .scrollPosition(id: $scrollPosition)
                        VStack(spacing: 20) {
                            HStack {
                                Text("プレミアムプランの特典")
                                    .font(.semiBold(size: 18))
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            VStack(spacing: 20) {
                                HStack {
                                    Text("広告なしで快適に利用できる")
                                        .font(.medium(size: 16))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                Divider()
                                HStack {
                                    Text("先月・去年と比較が可能")
                                        .font(.medium(size: 16))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                Divider()
                                HStack {
                                    Text("最大重量の成長グラフが閲覧できる")
                                        .font(.medium(size: 16))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                Divider()
                                HStack {
                                    Text("部位別のトータルボリュームが閲覧できる")
                                        .font(.medium(size: 16))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                            }
                            .padding()
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            HStack {
                                Text("これから追加する機能")
                                    .font(.semiBold(size: 18))
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            VStack(spacing: 20) {
                                HStack {
                                    Text("アプリアイコンの変更")
                                        .font(.medium(size: 16))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                Divider()
                                HStack {
                                    Text("テーマカラーの変更")
                                        .font(.medium(size: 16))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                Divider()
                                HStack {
                                    Text("週間ハイライトカード")
                                        .font(.medium(size: 16))
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                            }
                            .padding()
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            Text("その他にもたくさんの機能を考えております！🔥")
                                .font(.semiBold(size: 14))
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                    }
                }
                VStack(spacing: 0) {
                    Divider()
                    Text("２週間無料トライアルをタップすると、[利用規約](https://simple-workout-terms.web.app)及び[プライバシーポリシー](https://simple-workout-privacy.web.app/)に同意したことになり、料金が請求されます。App Storeの設定からキャンセルしない限り、このプランは同じ料金及び期間で自動的に更新されます。")
                        .font(.regular(size: 12))
                        .foregroundStyle(.white)
                        .padding(.top, 20)
                    Button {
                        // サブスク購入
                        Task {
                            await subscription.purchase(
                                subscription.products.first(where: { product in
                                    product.id == selectedProductId
                                })!
                            )
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Text("２週間無料トライアル")
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                            Text("その後 \(subscription.selectedProduct?.displayPrice ?? "")")
                                .foregroundStyle(.gray)
                        }
                        .padding(.vertical, 16)
                        .background(.blue.opacity(0.3))
                        .clipShape(Capsule())
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("プレミアム")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("復元") {
                        Task {
                            await subscription.restorePurchases()
                        }
                    }
                    .disabled(isPurchasing || subscription.isLoading)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .task {
                await subscription.loadProducts()
                await subscription.updateSubscriptionStatus()
                await subscription.currentSubscribedProductID()
                await subscription.checkSubscriptionStatus()
                let productId = subscription.products.first?.id
                selectedProductId = productId
                subscription.selectedProduct(for: productId)
            }
            .onChange(of: scrollPosition, { oldValue, newValue in
                selectedProductId = newValue
                subscription.selectedProduct(for: newValue)
            })
            .onChange(of: subscription.errorMessage) { _, newValue in
                if let msg = newValue {
                    alertItem = AlertItem(message: msg)
                    subscription.errorMessage = nil
                }
            }
            .overlay {
                if subscription.isLoading || isPurchasing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                }
            }
            .alert(item: $alertItem) { item in
                Alert(title: Text("エラー"), message: Text(item.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    SubscriptionView()
        .environmentObject(SubscriptionManager.shared)
}
