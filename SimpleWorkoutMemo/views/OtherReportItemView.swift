//
//  OtherReportView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/24.
//

import SwiftUI
import SwiftData

struct OtherReportItemView: View {
    @Query private var workoutDays: [WorkoutDay]
    
    let viewModel: ReportViewModel
    let reportType: Reportable
    let isThisWeek: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(viewModel.fetchReport(type: reportType, workoutDays: workoutDays))
                .font(.bold(size: 28))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(reportType.title)
                .font(.medium(size: 12))
                .foregroundStyle(.white)
            if isThisWeek {
                VStack(spacing: 0) {
                    Text("先週対比")
                        .font(.regular(size: 12))
                        .foregroundStyle(.gray)
                    Text(viewModel.fetchComparisonReport(type: reportType,
                                                         workoutDays: workoutDays))
                        .font(.regular(size: 12))
                        .foregroundStyle(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 6)
        .background(
            LinearGradient(colors: [.orange.opacity(0.4), .red.opacity(0.4)], startPoint: .top, endPoint: .bottom)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    OtherReportItemView(viewModel: ReportViewModel(), reportType: ThisWeekReportType.thisWeekTotalLoad, isThisWeek: true)
}
