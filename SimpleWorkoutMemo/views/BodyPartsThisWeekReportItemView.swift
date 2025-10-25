//
//  BodyPartsThisWeekReportItemView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/24.
//

import SwiftUI
import SwiftData
import Charts

struct BodyPartsThisWeekReportItemView: View {
    @Query var workoutDays: [WorkoutDay]
    
    let viewModel: ReportViewModel
    let parts: Parts
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(parts.color)
                        .opacity(0.6)
                        .frame(width: 50, height: 50)
                    Text(parts.title)
                        .font(.semiBold(size: 16))
                        .foregroundStyle(.white)
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            Chart {
                ForEach(viewModel.barMarkData(parts: parts, workoutDays: workoutDays)) { data in
                    BarMark(
                        x: .value("Name", data.period.title),
                        y: .value("Value", data.value),
                        width: 16
                    )
                    .foregroundStyle(by: .value("Category", data.category.title))
                    .position(by: .value("Category", data.category.title))
                    .annotation(position: .top) {
                        VStack(spacing: 0) {
                            Text("\(Int(data.value))")
                                .font(.medium(size: 16))
                            if data.period == .thisWeek {
                                Text(viewModel.getWeekCompareData(
                                    value: data.value,
                                    category: data.category,
                                    workoutDays: workoutDays,
                                    parts: parts))
                                .foregroundStyle(.green)
                                .font(.bold(size: 12))
                            }
                        }
                    }
                }
            }
            .frame(height: 200)
            .padding(.horizontal, 12)
        }
        .padding(.vertical, 20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
    }
}

#Preview {
    BodyPartsThisWeekReportItemView(viewModel: ReportViewModel(), parts: .chest)
}
