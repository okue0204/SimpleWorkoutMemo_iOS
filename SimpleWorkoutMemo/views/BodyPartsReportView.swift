//
//  BodyPartsReportView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/24.
//

import SwiftUI

struct BodyPartsReportView: View {
    
    @State private var isHideBanner: Bool = false
    @State private var timePeriod: TimePeriod = .today
    
    let viewModel: ReportViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Picker("Segment", selection: $timePeriod) {
                    ForEach(TimePeriod.nonAllCases, id: \.id) { period in
                        Text(period.title)
                            .tag(period)
                    }
                }.pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                BannerViewContainer {
                    isHideBanner = true
                }
                .frame(maxWidth: .infinity)
                .frame(height: isHideBanner ? 0 : 50)
                ForEach(Parts.allCases, id: \.id) { parts in
                    BodyPartsReportItemView(timePeriod: $timePeriod,
                                            viewModel: viewModel,
                                            parts: parts)
                }
            }
        }
        .navigationTitle("部位別レポート")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            AnalyticsManager.logEvent(.showThisWeekReport)
        }
    }
}

#Preview {
    BodyPartsReportView(viewModel: ReportViewModel())
}
