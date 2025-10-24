//
//  OtherReportView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/24.
//

import SwiftUI

struct OtherReportView: View {
    
    let viewModel: ReportViewModel
    let isThisWeek: Bool
    
    var body: some View {
        NavigationLink {
            if isThisWeek {
                BodyPartsThisWeekReportView()
            }
        } label: {
            VStack(spacing: 12) {
                HStack {
                    Text(isThisWeek ? "今週の記録" : "トータルの記録")
                        .foregroundStyle(.white)
                        .font(.regular(size: 16))
                    Spacer()
                    if isThisWeek {
                        Image(.icWorkoutRightArrow)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                    }
                }
                LazyVGrid(columns: Array(repeating: .init(), count: isThisWeek ? 3 : 2)) {
                    if isThisWeek {
                        ForEach(ThisWeekReportType.allCases, id: \.id) { type in
                            OtherReportItemView(viewModel: viewModel, reportType: type, isThisWeek: true)
                        }
                    } else {
                        ForEach(ReportType.allCases, id: \.id) { type in
                            OtherReportItemView(viewModel: viewModel, reportType: type, isThisWeek: false)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    @Previewable @State var isShowThisWeekReport: Bool = false
    OtherReportView(viewModel: ReportViewModel(), isThisWeek: true)
}
