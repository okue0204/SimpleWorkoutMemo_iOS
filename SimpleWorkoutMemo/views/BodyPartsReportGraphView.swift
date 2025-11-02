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
    @EnvironmentObject var subscription: SubscriptionManager
    @Query var workoutDays: [WorkoutDay]
    @Binding var timePeriod: TimePeriod
    @State var viewModel: BodyPartsReportGraphViewModel
    @State private var isShowDetail = false
    @State private var isShowPremium = false
    
    let parts: Parts
    
    var body: some View {
        ZStack {
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
                case .today, .thisWeek, .thisMonth, .thisYear:
                    VStack {
                        Chart {
                            ForEach(viewModel.barMarkData) { data in
                                BarMark(
                                    x: .value("Name", data.period.title),
                                    y: .value("Value", data.value),
                                    width: 16
                                )
                                .foregroundStyle(by: .value("Category", data.category.title))
                                .position(by: .value("Category", data.category.title))
                                .annotation(position: .top) {
                                    VStack(spacing: 0) {
                                        Text("\(data.value)")
                                            .font(.regular(size: 14))
                                            .foregroundStyle(.white)
                                        switch data.category {
                                        case .set:
                                            if data.period.isThisPeriod {
                                                Text(viewModel.setCompareData)
                                                .foregroundStyle(.green)
                                                .font(.bold(size: 12))
                                            }
                                        case .rep:
                                            if data.period.isThisPeriod {
                                                Text(viewModel.repCompareData)
                                                .foregroundStyle(.green)
                                                .font(.bold(size: 12))
                                            }
                                        case .totalLoad:
                                            if data.period.isThisPeriod {
                                                Text(viewModel.totalWeightCompareData)
                                                .foregroundStyle(.green)
                                                .font(.bold(size: 12))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .frame(height: 200)
                        .padding(.horizontal, 12)
                        if timePeriod == .thisWeek || timePeriod == .thisMonth || timePeriod == .thisYear {
                            Button {
                                withAnimation {
                                    isShowDetail.toggle()
                                }
                            } label: {
                                Text(isShowDetail ? "レポートデータを閉じる" : "さらにレポートデータを表示")
                                    .foregroundStyle(.blue)
                                    .font(.regular(size: 14))
                            }
                            .padding(.top, 12)
                            if isShowDetail {
                                Divider()
                                    .padding(.horizontal, 12)
                                ScrollView {
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text("パーセント")
                                                .foregroundStyle(.white)
                                                .font(.semiBold(size: 16))
                                            Spacer()
                                        }
                                        .padding(.bottom, 6)
                                        HStack {
                                            Text("総負荷量")
                                                .font(.medium(size: 14))
                                                .foregroundStyle(.white)
                                                .padding(.leading, 12)
                                            Spacer()
                                            HStack(spacing: 0) {
                                                Text(viewModel.percentageCompareData)
                                                    .font(.bold(size: 14))
                                                    .foregroundStyle(.white)
                                                if let isUpPercentage = viewModel.isUpPercentage {
                                                    Text(isUpPercentage ? "🔥" : "😞")
                                                }
                                            }
                                            .padding(.trailing, 12)
                                        }
                                        .padding(.vertical, 12)
                                        .background(Color(.systemGray5))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.top, 12)
                                }
                            }
                        }
                    }
                case .all:
                    fatalError("Invalid timePeriod")
                }
            }
            .blur(radius: blurRadius())
            .padding(.vertical, 20)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)
            .onAppear {
                viewModel.barMarkData(parts: parts, workoutDays: workoutDays, timePeriod: timePeriod)
                viewModel.getCompareData(workoutDays: workoutDays, parts: parts, timePeriod: timePeriod)
                viewModel.calculatePercentage(timePeriod: timePeriod)
            }
            .onChange(of: timePeriod) { oldValue, newValue in
                viewModel.barMarkData(parts: parts, workoutDays: workoutDays, timePeriod: newValue)
                viewModel.getCompareData(workoutDays: workoutDays, parts: parts, timePeriod: newValue)
                viewModel.calculatePercentage(timePeriod: timePeriod)
            }
            if !subscription.isSubscribed, timePeriod == .thisMonth || timePeriod == .thisYear {
                VStack(spacing: 12) {
                    Text("プレムアムプランで表示")
                        .font(.semiBold(size: 16))
                        .foregroundStyle(.white)
                    Button {
                        isShowPremium.toggle()
                    } label: {
                        Text("プレミアムプランを確認する")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.blue.opacity(0.3))
                            .font(.semiBold(size: 16))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .sheet(isPresented: $isShowPremium) {
            SubscriptionView()
                .environmentObject(SubscriptionManager.shared)
        }
    }
    
    private func blurRadius() -> CGFloat {
        if !subscription.isSubscribed,
           timePeriod == .thisMonth || timePeriod == .thisYear {
            8
        } else {
            0
        }
    }
}

#Preview("today", body: {
    @Previewable @State var timePeriod: TimePeriod = .today
    BodyPartsReportGraphView(timePeriod: $timePeriod,
                            viewModel: BodyPartsReportGraphViewModel(),
                            parts: .chest)
    .environmentObject(SubscriptionManager.shared)
})

#Preview("week", body: {
    @Previewable @State var timePeriod: TimePeriod = .thisWeek
    BodyPartsReportGraphView(timePeriod: $timePeriod,
                            viewModel: BodyPartsReportGraphViewModel(),
                            parts: .chest)
    .environmentObject(SubscriptionManager.shared)
})

#Preview("month", body: {
    @Previewable @State var timePeriod: TimePeriod = .thisMonth
    BodyPartsReportGraphView(timePeriod: $timePeriod,
                            viewModel: BodyPartsReportGraphViewModel(),
                            parts: .chest)
    .environmentObject(SubscriptionManager.shared)
})

#Preview("year", body: {
    @Previewable @State var timePeriod: TimePeriod = .thisYear
    BodyPartsReportGraphView(timePeriod: $timePeriod,
                            viewModel: BodyPartsReportGraphViewModel(),
                            parts: .chest)
    .environmentObject(SubscriptionManager.shared)
})
