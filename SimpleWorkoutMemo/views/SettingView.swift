//
//  SettingView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/07.
//

import SwiftUI
import StoreKit

struct SettingView: View {
    
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
    
    @State var settingSheetType: SettingSheetType?
    
    private var displayWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        HeaderView(title: "設定",
                   imageResource: .icWorkoutClose,
                   isFromHome: false) { _ in
            dismiss()
        }
                   .padding(.vertical, 12)
        BannerViewContainer {}
        .frame(width: displayWidth, height: 50)
        VStack(spacing: 0) {
            List {
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
            BannerViewContainer {}
            .frame(width: displayWidth, height: 100)
        }
        .ignoresSafeArea(.container)
    }
}

#Preview {
    SettingView()
}
