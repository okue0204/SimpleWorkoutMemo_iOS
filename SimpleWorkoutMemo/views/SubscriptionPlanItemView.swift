//
//  SubscriptionPlanItemView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/11/02.
//

import SwiftUI
import StoreKit

struct SubscriptionPlanItemView: View {
    @EnvironmentObject var subscription: SubscriptionManager
    @Binding var selectedProductId: String?
    
    let productId: String
    let name: String
    let price: String
    let plan: SubscriptionPlan
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(name)
                    .font(.semiBold(size: 26))
                    .foregroundStyle(.white)
                Spacer()
                Image(.icWorkoutCheck)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding(.top, 20)
            if subscription.currentProductID == plan.productID {
                HStack {
                    Text("加入中")
                        .font(.semiBold(size: 16))
                        .foregroundStyle(.yellow)
                    Spacer()
                }
            }
            if subscription.subscriptionStatus == .trial, subscription.currentProductID == plan.productID {
                HStack {
                    Text("無料トライアル中")
                        .font(.semiBold(size: 14))
                        .foregroundStyle(.yellow)
                    Spacer()
                }
                .padding(.top, 6)
            }
            Spacer()
            HStack {
                Text(price)
                    .font(.semiBold(size: 18))
                    .foregroundStyle(.white)
                Spacer()
                if SubscriptionPlan.yearly.productID == productId {
                    Text("２ヶ月分お得")
                        .font(.bold(size: 12))
                        .foregroundStyle(.yellow)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(Color(.systemGray4))
                        .clipShape(Capsule())
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 20)
        .frame(height: 160)
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            if plan.productID == selectedProductId {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 2)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
    }
}

#Preview {
    @Previewable @State var selectedProductId: String? = nil
    SubscriptionPlanItemView(selectedProductId: $selectedProductId,
                             productId: "",
                             name: "1ヶ月",
                             price: "￥180",
                             plan: .yearly)
    .environmentObject(SubscriptionManager.shared)
}
