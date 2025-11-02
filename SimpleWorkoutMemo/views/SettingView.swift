//
//  SettingView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/07.
//

import SwiftUI
import StoreKit

struct SettingView: View {
    
    enum SettingsRoute: Hashable {
        case subscription
    }
    
    enum SettingSheetType: String, View, Identifiable {
        case term
        case privacy
        case inquiry
        
        var id: String {
            rawValue
        }
        
        var body: some View {
            switch self {
            case .term:
                AnyView(WebView(url: EnvironmentConstant.termOfServiceURL))
            case .privacy:
                AnyView(WebView(url: EnvironmentConstant.privacyPolicyURL))
            case .inquiry:
                MailView()
            }
        }
    }
    
    @Environment(\.requestReview) var requestReview
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var subscription: SubscriptionManager
    
    @State var settingSheetType: SettingSheetType?
    @State private var isHideBanner: Bool = false
    @State private var path = NavigationPath()
    @State private var showSubscription: Bool = false
    
    private var displayWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            BannerViewContainer {
                isHideBanner = true
            }
            .frame(width: displayWidth,
                   height: subscription.isSubscribed ? 0 : isHideBanner ? 0 : 50)
            VStack(spacing: 0) {
                List {
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.bold(size: 24))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("プレミアムを体験")
                                .font(.semiBold(size: 18))
                                .foregroundStyle(.white)
                            Text("広告なし・全機能・優先サポート")
                                .font(.regular(size: 12))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        Spacer()
                        Text("詳細")
                            .font(.regular(size: 14))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                    .padding(12)
                    .background(
                        LinearGradient(colors: [Color.accentColor.opacity(0.75), Color.accentColor.opacity(0.45)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    )
                    .contentShape(Rectangle())
                    .onTapGesture { showSubscription = true }
                    .listRowBackground(Color.clear)
                    
                    Section {
                        Button {
                            settingSheetType = .term
                        } label: {
                            Text("利用規約")
                                .foregroundStyle(.white)
                                .font(.regular(size: 16))
                        }
                        Button {
                            settingSheetType = .privacy
                        } label: {
                            Text("プライバシーポリシー")
                                .foregroundStyle(.white)
                                .font(.regular(size: 16))
                        }
                    } header: {
                        Text("インフォメーション")
                            .font(.regular(size: 14))
                    }
                    Section {
                        Button {
                            settingSheetType = .inquiry
                        } label: {
                            Text("お問い合わせ")
                                .foregroundStyle(.white)
                                .font(.regular(size: 16))
                        }
                        Button {
                            requestReview()
                            AnalyticsManager.logEvent(.showReview)
                        } label: {
                            Text("レビュー")
                                .foregroundStyle(.white)
                                .font(.regular(size: 16))
                        }
                    } header: {
                        Text("フィードバック")
                            .font(.regular(size: 14))
                    }
        //            Section {
        //                Button {
        //                    AnalyticsManager.logEvent(.showShare)
        //                } label: {
        //                    Text("共有")
        //                        .foregroundStyle(.white)
        //                        .font(.regular(size: 16))
        //                }
        //            } header: {
        //                Text("シェア")
        //                    .font(.regular(size: 14))
        //            }
                    Section {
                        HStack {
                            Text("バージョン")
                                .foregroundStyle(.white)
                                .font(.regular(size: 16))
                            Spacer()
                            Text(EnvironmentConstant.appVersion)
                                .foregroundStyle(.white)
                                .font(.regular(size: 16))
                        }
                    } header: {
                        Text("その他")
                            .font(.regular(size: 14))
                    }
                }
                .sheet(item: $settingSheetType) { $0 }
                .sheet(isPresented: $showSubscription) {
                    SubscriptionView()
                        .environmentObject(SubscriptionManager.shared)
                }
                BannerViewContainer {
                    isHideBanner = true
                }
                .frame(width: displayWidth, height: isHideBanner ? 0 : 100)
            }
            .ignoresSafeArea(.container)
            .navigationTitle("設定")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(.icWorkoutClose)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.white)
                    }

                }
            }
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(SubscriptionManager.shared)
}
