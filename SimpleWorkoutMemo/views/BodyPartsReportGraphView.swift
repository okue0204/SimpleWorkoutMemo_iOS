//
//  BodyPartsThisWeekReportItemView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/24.
//

import SwiftUI
import SwiftData
import Charts

struct BodyPartsReportGraphView: View {
    @Query var workoutDays: [WorkoutDay]
    @Binding var timePeriod: TimePeriod
    
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
                VStack(spacing: 6) {
                    switch timePeriod {
                    case .all:
                        EmptyView()
                    case .today:
                        Text(DateFormatter.dateToString(Date().firstDayOfPeriod(for: timePeriod), format: .monthDay))
                            .foregroundStyle(.gray)
                            .font(.regular(size: 12))
                    case .thisWeek, .thisMonth, .thisYear:
                        HStack {
                            Text(timePeriod.graphTitle)
                            Text(DateFormatter.dateToString(Date().firstDayOfPeriod(for: timePeriod), format: timePeriod == .thisYear ? .year : .monthDay))
                            switch timePeriod {
                            case .thisWeek, .thisMonth:
                                Text("〜")
                                Text(DateFormatter.dateToString(Date().lastDayOfPeriod(for: timePeriod), format: .monthDay))
                            default:
                                EmptyView()
                            }
                        }
                        .foregroundStyle(.gray)
                        .font(.regular(size: 12))
                        HStack {
                            Text(timePeriod.previousGraphTitle)
                            Text(DateFormatter.dateToString(Date().previousPeriodArray(for: timePeriod).first!, format: timePeriod == .thisYear ? .year : .monthDay))
                            switch timePeriod {
                            case .thisWeek, .thisMonth:
                                Text("〜")
                                Text(DateFormatter.dateToString(Date().previousPeriodArray(for: timePeriod).last!, format: timePeriod == .thisYear ? .year : .monthDay))
                            default:
                                EmptyView()
                            }
                        }
                        .foregroundStyle(.gray)
                        .font(.regular(size: 12))
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            switch timePeriod {
            case .today:
                Chart {
                    ForEach(viewModel.barMarkData(parts: parts, workoutDays: workoutDays, timePeriod: .today)) { data in
                        BarMark(
                            x: .value("Name", data.period.title),
                            y: .value("Value", data.value),
                            width: 16
                        )
                        .foregroundStyle(by: .value("Category", data.category.title))
                        .position(by: .value("Category", data.category.title))
                        .annotation(position: .top) {
                            Text("\(Int(data.value))")
                                .font(.medium(size: 16))
                        }
                    }
                }
                .frame(height: 200)
                .padding(.horizontal, 12)
            case .thisWeek, .thisMonth, .thisYear:
                Chart {
                    ForEach(viewModel.barMarkData(parts: parts, workoutDays: workoutDays, timePeriod: timePeriod)) { data in
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
                                if data.period.isThisPeriod {
                                    Text(viewModel.getWeekCompareData(
                                        value: data.value,
                                        category: data.category,
                                        workoutDays: workoutDays,
                                        parts: parts,
                                        timePeriod: timePeriod))
                                    .foregroundStyle(.green)
                                    .font(.bold(size: 12))
                                }
                            }
                        }
                    }
                }
                .frame(height: 200)
                .padding(.horizontal, 12)
            case .all:
                fatalError("Invalid timePeriod")
            }
        }
        .padding(.vertical, 20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
    }
}

#Preview("today", body: {
    @Previewable @State var timePeriod: TimePeriod = .today
    BodyPartsReportGraphView(timePeriod: $timePeriod,
                            viewModel: ReportViewModel(),
                            parts: .chest)
})

#Preview("week", body: {
    @Previewable @State var timePeriod: TimePeriod = .thisWeek
    BodyPartsReportGraphView(timePeriod: $timePeriod,
                            viewModel: ReportViewModel(),
                            parts: .chest)
})

#Preview("month", body: {
    @Previewable @State var timePeriod: TimePeriod = .thisMonth
    BodyPartsReportGraphView(timePeriod: $timePeriod,
                            viewModel: ReportViewModel(),
                            parts: .chest)
})

#Preview("year", body: {
    @Previewable @State var timePeriod: TimePeriod = .thisYear
    BodyPartsReportGraphView(timePeriod: $timePeriod,
                            viewModel: ReportViewModel(),
                            parts: .chest)
})

