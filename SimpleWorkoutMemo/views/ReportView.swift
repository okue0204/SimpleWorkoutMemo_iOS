//
//  ReportView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/21.
//

import SwiftUI

struct ReportView: View {
    
    @State var viewModel: ReportViewModel
    
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
                            ContinuousRecordView()
                            OtherReportView(viewModel: viewModel,
                                            isThisWeek: true)
                            OtherReportView(viewModel: viewModel,
                                            isThisWeek: false)
                        }
                    }
                    Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.safeAreaInsets.bottom)
                }
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ReportView(viewModel: ReportViewModel())
}
