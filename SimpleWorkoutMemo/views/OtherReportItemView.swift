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
    let timePeriod: TimePeriod
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(viewModel.fetchPeriodReport(type: reportType, workoutDays: workoutDays))
                .font(.bold(size: 28))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(reportType.title(for: timePeriod))
                .font(.medium(size: 12))
                .foregroundStyle(.white)
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
    OtherReportItemView(viewModel: ReportViewModel(),
                        reportType: ReportType.totalLoad,
                        timePeriod: .today)
}
