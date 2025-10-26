//
//  ReportView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/21.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var appStorageManager: AppStorageManager
    @State var viewModel: ReportViewModel
    @State private var settingTargetText: String = ""
    @State private var isHideBanner: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.safeAreaInsets.top)
                    HeaderView(title: "レポート", imageResource: nil, isFromHome: false) { _ in }
                        .padding(.bottom, 12)
                    ScrollView {
                        VStack(spacing: 20) {
                            BannerViewContainer {
                                isHideBanner = true
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: isHideBanner ? 0 : 50)
                            ContinuousRecordView(viewModel: viewModel)
                                .environmentObject(appStorageManager)
                            OtherReportView(viewModel: viewModel,
                                            timePeriod: .today)
                            OtherReportView(viewModel: viewModel,
                                            timePeriod: .all)
                        }
                    }
                    Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.safeAreaInsets.bottom)
                }
                .ignoresSafeArea()
            }
        }
        .onAppear(perform: {
            viewModel.showSettingTargetDaysAlertIfNeeded()
        })
        .alert("ワークアウト設定", isPresented: $viewModel.isShowSettingTargetDays) {
            TextField("日数を指定", text: $settingTargetText)
                .keyboardType(.numberPad)
            Button("OK") {
                viewModel.settingTargetDays = Int(settingTargetText) ?? 0
            }
        } message: {
            Text("週に何日トレーニングを行いますか？")
                .font(.regular(size: 14))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    ReportView(viewModel: ReportViewModel())
        .environmentObject(AppStorageManager.shared)
}
