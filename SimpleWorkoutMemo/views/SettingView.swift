//
//  SettingView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/07.
//

import SwiftUI
import StoreKit

struct SettingView: View {
    @Environment(\.requestReview) var requestReview
    @Environment(\.dismiss) var dismiss
    
    @State private var isShowMail: Bool = false
    
    var body: some View {
        HeaderView(title: "設定",
                   imageResource: .icWorkoutClose,
                   isFromHome: false) { _ in
            dismiss()
        }
                   .padding(.vertical, 12)
        List {
            Section {
                Button {
                    
                } label: {
                    Text("利用規約")
                        .foregroundStyle(.white)
                        .font(.regular(size: 16))
                }
                Button {
                    
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
                    isShowMail.toggle()
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
            Section {
                Button {
                    AnalyticsManager.logEvent(.showShare)
                } label: {
                    Text("共有")
                        .foregroundStyle(.white)
                        .font(.regular(size: 16))
                }
            } header: {
                Text("シェア")
                    .font(.regular(size: 14))
            }

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
        .sheet(isPresented: $isShowMail) {
            MailView()
        }
    }
}

#Preview {
    SettingView()
}
