//
//  BodyPartsReportGraphViewModel.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/30.
//

import Foundation
import SwiftUI
import Observation

@Observable
class BodyPartsReportGraphViewModel {
    
    var barMarkData: [BarMarkReport] = []
    var setCompareData: String = ""
    var repCompareData: String = ""
    var totalWeightCompareData: String = ""
    var percentageCompareData: String = ""
    var isUpPercentage: Bool?
    
    // 棒グラフ用のデータ
    func barMarkData(parts: Parts, workoutDays: [WorkoutDay], timePeriod: TimePeriod) {
        
        let currentPeriod: (any Periodable)? = switch timePeriod {
        case .thisWeek:
            WeekPeriod.thisWeek
        case .thisMonth:
            MonthPeriod.thisMonth
        case .thisYear:
            YearPeriod.thisYear
        case .today:
            TodayPeriod.today
        default:
            nil
        }
        
        let previousPeriod: (any Periodable)? = switch timePeriod {
        case .thisWeek:
            WeekPeriod.lastWeek
        case .thisMonth:
            MonthPeriod.lastMonth
        case .thisYear:
            YearPeriod.lastYear
        default:
            nil
        }
        
        let currentPeriodDates: [Date] = switch timePeriod {
        case .thisWeek:
            Date().currentWeekDates
        case .thisMonth:
            Date().currentMonthDates
        case .thisYear:
            Date().currentYearDates
        case .today:
            [Date()]
        default:
            []
        }
        
        let previousPeriodDates: [Date] = switch timePeriod {
        case .thisWeek:
            Date().lastWeekDates
        case .thisMonth:
            Date().lastMonthDates
        case .thisYear:
            Date().lastYearDates
        default:
            []
        }
        
        // 今週・今月・今年の部位(仮: 胸)のセット・レップ・総負荷量のデータを取得
        let filteredCurrentPeriodWorkouts = workoutDays.filter { workoutDay in
            currentPeriodDates.contains { date in
                date.zeroClock == workoutDay.createdAt.zeroClock
            }
        }.flatMap { workoutDay in
            workoutDay.workouts.filter { workout in
                workout.exercise?.parts == parts
            }
        }
        let currentPeriodTotalSet = filteredCurrentPeriodWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.workoutSetInfo.count
        }
        let currentPeriodTotalRep = filteredCurrentPeriodWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalRep
        }
        let currentPeriodTotalLoad = filteredCurrentPeriodWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalWeight
        }
        
        
        guard let currentPeriod else {
            barMarkData = []
            return
        }
        let currentPeriodBarMarkReports: [BarMarkReport] = [
            .init(period: currentPeriod, value: currentPeriodTotalSet, category: BarMarkReportCategory.set),
            .init(period: currentPeriod, value: currentPeriodTotalRep, category: BarMarkReportCategory.rep),
            .init(period: currentPeriod, value: currentPeriodTotalLoad, category: BarMarkReportCategory.totalLoad)
        ]
        
        // 先週・先月・去年の部位(仮: 胸)のセット・レップ・総負荷量のデータを取得
        let filteredPreviousPeriodWorkouts = workoutDays.filter { workoutDay in
            previousPeriodDates.contains { date in
                date.zeroClock == workoutDay.createdAt.zeroClock
            }
        }.flatMap { workoutDay in
            workoutDay.workouts.filter { workout in
                workout.exercise?.parts == parts
            }
        }
        let previousPeriodTotalSet = filteredPreviousPeriodWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.workoutSetInfo.count
        }
        let previousPeriodTotalRep = filteredPreviousPeriodWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalRep
        }
        let previousPeriodTotalLoad = filteredPreviousPeriodWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalWeight
        }
        
        guard let previousPeriod else {
            //　今日の場合のみ通る
            barMarkData = currentPeriodBarMarkReports
            return
        }
        let previousPeriodBarMarkReports: [BarMarkReport] = [
            .init(period: previousPeriod, value: previousPeriodTotalSet, category: BarMarkReportCategory.set),
            .init(period: previousPeriod, value: previousPeriodTotalRep, category: BarMarkReportCategory.rep),
            .init(period: previousPeriod, value: previousPeriodTotalLoad, category: BarMarkReportCategory.totalLoad)
        ]
        
        barMarkData = previousPeriodBarMarkReports + currentPeriodBarMarkReports
    }
    
    // BarMarkReportの共通集計関数
    private func filterBarMarkPeriodValues<T: Periodable>(currentPeriod: T) -> (set: Int, rep: Int, totalLoad: Int) {
        let filtered: [(category: BarMarkReportCategory, value: Int)] = barMarkData.compactMap { report -> (BarMarkReportCategory, Int)? in
            guard let period = report.period as? T, period == currentPeriod else { return nil }
            return (report.category, report.value)
        }
        
        // カテゴリごとに値を取得
        func value(for category: BarMarkReportCategory) -> Int {
            filtered.first {
                $0.category == category
            }?.value ?? 0
        }
        
        return (
            set: value(for: .set),
            rep: value(for: .rep),
            totalLoad: value(for: .totalLoad)
        )
    }
    
    // 今週と先週・今月と先月・今年と去年の比較用(部位ごと)
    func getCompareData(workoutDays: [WorkoutDay], parts: Parts, timePeriod: TimePeriod) {
        guard timePeriod != .today else {
            return
        }
        let previousPeriodDates: [Date] = switch timePeriod {
        case .thisWeek:
            Date().lastWeekDates
        case .thisMonth:
            Date().lastMonthDates
        case .thisYear:
            Date().lastYearDates
        default:
            []
        }
        
        let previousDateSet = Set(previousPeriodDates.map { $0.zeroClock })
        let filteredPreviousPeriodWorkouts = workoutDays.filter { workoutDay in
            previousDateSet.contains { date in
                date.zeroClock == workoutDay.createdAt.zeroClock
            }
        }.flatMap { workoutDay in
            workoutDay.workouts.filter { workout in
                workout.exercise?.parts == parts
            }
        }
        let previousPeriodTotalSet = filteredPreviousPeriodWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.workoutSetInfo.count
        }
        let previousPeriodTotalRep = filteredPreviousPeriodWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalRep
        }
        let previousPeriodTotalLoad = filteredPreviousPeriodWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalWeight
        }
        
        let currentValue: (set: Int, rep: Int, totalLoad: Int) = switch timePeriod {
        case .thisWeek:
            filterBarMarkPeriodValues(currentPeriod: WeekPeriod.thisWeek)
        case .thisMonth:
            filterBarMarkPeriodValues(currentPeriod: MonthPeriod.thisMonth)
        case .thisYear:
            filterBarMarkPeriodValues(currentPeriod: YearPeriod.thisYear)
        default:
            fatalError()
        }
        
        let setSymbol = currentValue.set > previousPeriodTotalSet ? "+" : ""
        let repSymbol = currentValue.rep > previousPeriodTotalRep ? "+" : ""
        let totalWeightSymbol = currentValue.totalLoad > previousPeriodTotalLoad ? "+" : ""
        
        let isShowSetFire = currentValue.set > previousPeriodTotalSet
        let isShowRepFire = currentValue.rep > previousPeriodTotalRep
        let isShowTotalWeightFire = currentValue.totalLoad > previousPeriodTotalLoad
        
        setCompareData = setSymbol + String(abs(currentValue.set) - abs(previousPeriodTotalSet)) + (isShowSetFire ? "🔥" : "")
        repCompareData = repSymbol + String(abs(currentValue.rep) - abs(previousPeriodTotalRep)) + (isShowRepFire ? "🔥" : "")
        totalWeightCompareData = totalWeightSymbol + String(abs(currentValue.totalLoad) - abs(previousPeriodTotalLoad)) + (isShowTotalWeightFire ? "🔥" : "")
    }
    
    // データを比較して何%成長orダウンしたか計算
    func calculatePercentage(timePeriod: TimePeriod) {
        guard timePeriod != .today else { return }
        
        let currentValue: (set: Int, rep: Int, totalLoad: Int) = switch timePeriod {
        case .thisWeek:
            filterBarMarkPeriodValues(currentPeriod: WeekPeriod.thisWeek)
        case .thisMonth:
            filterBarMarkPeriodValues(currentPeriod: MonthPeriod.thisMonth)
        case .thisYear:
            filterBarMarkPeriodValues(currentPeriod: YearPeriod.thisYear)
        default:
            fatalError()
        }
        
        let previousValue: (set: Int, rep: Int, totalLoad: Int) = switch timePeriod {
        case .thisWeek:
            filterBarMarkPeriodValues(currentPeriod: WeekPeriod.lastWeek)
        case .thisMonth:
            filterBarMarkPeriodValues(currentPeriod: MonthPeriod.lastMonth)
        case .thisYear:
            filterBarMarkPeriodValues(currentPeriod: YearPeriod.lastYear)
        default:
            fatalError()
        }
        
        let currentTotalLoad = Double(currentValue.totalLoad)
        let previousTotalLoad = Double(previousValue.totalLoad)
        
        guard currentTotalLoad != 0, previousTotalLoad != 0 else {
            isUpPercentage = nil
            percentageCompareData = "0%"
            return
        }
        
        let result = if currentTotalLoad > previousTotalLoad {
            // 増加率計算
            "+" + String(Int((currentTotalLoad - previousTotalLoad) / previousTotalLoad * 100)) + "%"
        } else {
            // 減少率計算
            "-" + String(Int((previousTotalLoad - currentTotalLoad) / previousTotalLoad * 100)) + "%"
        }
        isUpPercentage = currentTotalLoad > previousTotalLoad
        percentageCompareData = result
    }
}
