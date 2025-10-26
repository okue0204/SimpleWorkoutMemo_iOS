//
//  OtherReportView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/24.
//

import SwiftUI

struct OtherReportView: View {
    
    let viewModel: ReportViewModel
    let timePeriod: TimePeriod
    
    var body: some View {
        switch timePeriod {
        case .all:
            reportContent
        default:
            NavigationLink {
                BodyPartsReportView(viewModel: viewModel)
            } label: {
                reportContent
            }
        }
    }
    
    private var reportContent: some View {
        VStack(spacing: 12) {
            HStack {
                Text(timePeriod == .all ? "トータルの記録" : "記録")
                    .foregroundStyle(.white)
                    .font(.regular(size: 16))
                Spacer()
                switch timePeriod {
                case .all:
                    EmptyView()
                default:
                    Image(.icWorkoutRightArrow)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
            }
            LazyVGrid(columns: Array(repeating: .init(), count: timePeriod == .all ? 2 : 3)) {
                switch timePeriod {
                case .all:
                    ForEach(AllReportType.allCases, id: \.id) { type in
                        OtherReportItemView(viewModel: viewModel, reportType: type, timePeriod: .all)
                    }
                default:
                    ForEach(ReportType.allCases, id: \.id) { type in
                        OtherReportItemView(viewModel: viewModel, reportType: type, timePeriod: timePeriod)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OtherReportView(viewModel: ReportViewModel(), timePeriod: .today)
}
