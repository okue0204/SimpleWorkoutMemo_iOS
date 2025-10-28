//
//  ReportViewModel.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/24.
//

import Foundation
import SwiftUI
import Observation

@Observable
class ReportViewModel: ObservableObject {
    
    private let appStorageManager = AppStorageManager.shared
    
    var isShowSettingTargetDays: Bool = false
    
    var settingTargetDays: Int {
        get {
            appStorageManager.settingTargetDays
        }
        set {
            appStorageManager.settingTargetDays = newValue
        }
    }
    
    var didShowSettingTargetDays: Bool {
        get {
            appStorageManager.didShowSettingTargetDays
        }
        set {
            appStorageManager.didShowSettingTargetDays = newValue
        }
    }
    
    private func weekTotalSets(workoutDays: [WorkoutDay], isThisWeek: Bool = true) -> Int {
        let weekDates = isThisWeek ? Date().currentWeekDates : Date().lastWeekDates
        let weekWorkoutDays = workoutDays.filter { workoutDay in
            weekDates.contains { date in
                date.zeroClock == workoutDay.createdAt.zeroClock
            }
        }
        let weekTotalSetCount = weekWorkoutDays.reduce(into: 0) { partialResult, workoutDay in
            let sets = workoutDay.workouts.map { workout in
                workout.workoutSetInfo.count
            }
            partialResult += sets.reduce(0, +)
        }
        return weekTotalSetCount
    }
    
    private func weekTotalReps(workoutDays: [WorkoutDay], isThisWeek: Bool = true) -> Int {
        let weekDates = isThisWeek ? Date().currentWeekDates : Date().lastWeekDates
        let weekWorkoutDays = workoutDays.filter { workoutDay in
            weekDates.contains { date in
                date.zeroClock == workoutDay.createdAt.zeroClock
            }
        }
        let weekTotalRepCount = weekWorkoutDays.reduce(into: 0) { partialResult, workoutDay in
            let reps = workoutDay.workouts.map { workout in
                workout.totalRep
            }
            partialResult += reps.reduce(0, +)
        }
        return weekTotalRepCount
    }
    
    private func weekTotalLoad(workoutDays: [WorkoutDay], isThisWeek: Bool = true) -> Int {
        let weekDates = isThisWeek ? Date().currentWeekDates : Date().lastWeekDates
        let weekWorkoutDays = workoutDays.filter { workoutDay in
            weekDates.contains { date in
                date.zeroClock == workoutDay.createdAt.zeroClock
            }
        }
        let weekTotalWeight = weekWorkoutDays.reduce(into: 0) { partialResult, workoutDay in
            let totalWeight = workoutDay.workouts.map { workout in
                workout.totalWeight
            }
            partialResult += totalWeight.reduce(0, +)
        }
        return weekTotalWeight
    }
    
    func fetchPeriodReport(type: Reportable, workoutDays: [WorkoutDay]) -> String {
        if let reportType = type as? AllReportType {
            switch reportType {
            case .allTotalDays:
                return String(workoutDays.count)
            case .allTotalSets:
                let totalSetCount = workoutDays.reduce(into: 0) { partialResult, workoutDay in
                    let sets = workoutDay.workouts.map { workout in
                        workout.workoutSetInfo.count
                    }
                    partialResult += sets.reduce(0, +)
                }
                let totalSetsStringCount = String(totalSetCount).count
                if totalSetsStringCount >= 4 {
                    let result = Double(totalSetCount) / 1000
                    return String(format: "%.1f", result) + "k"
                } else {
                    return String(totalSetCount)
                }
            case .allTotalReps:
                let totalReps = workoutDays.reduce(into: 0) { partialResult, workoutDay in
                    let reps = workoutDay.workouts.map { workout in
                        workout.totalRep
                    }
                    partialResult += reps.reduce(0, +)
                }
                let totalRepsStringCount = String(totalReps).count
                if totalRepsStringCount >= 4 {
                    let result = Double(totalReps) / 1000
                    return String(format: "%.1f", result) + "k"
                } else {
                    return String(totalReps)
                }
            case .allTotalLoad:
                let totalWeight = workoutDays.reduce(into: 0) { partialResult, workoutDay in
                    let weight = workoutDay.workouts.map { workout in
                        workout.totalWeight
                    }
                    partialResult += weight.reduce(0, +)
                }
                let totalWeightStringCount = String(totalWeight).count
                if totalWeightStringCount >= 4 {
                    let result = Double(totalWeight) / 1000
                    return String(format: "%.1f", result) + "t"
                } else {
                    return "\(totalWeight)kg"
                }
            }
        } else if let thisWeekReportType = type as? ReportType {
            switch thisWeekReportType {
            case .totalSets:
                let weekTotalSetCount = weekTotalSets(workoutDays: workoutDays)
                let totalSetsStringCount = String(weekTotalSetCount).count
                if totalSetsStringCount >= 4 {
                    let result = Double(totalSetsStringCount) / 1000
                    return String(format: "%.1f", result) + "k"
                } else {
                    return String(weekTotalSetCount)
                }
            case .totalReps:
                let weekTotalRepCount = weekTotalReps(workoutDays: workoutDays)
                let totalRepsStringCount = String(weekTotalRepCount).count
                if totalRepsStringCount >= 4 {
                    let result = Double(totalRepsStringCount) / 1000
                    return String(format: "%.1f", result) + "k"
                } else {
                    return String(weekTotalRepCount)
                }
            case .totalLoad:
                let weekTotalWeight = weekTotalLoad(workoutDays: workoutDays)
                let totalLoadStringCount = String(weekTotalWeight).count
                if totalLoadStringCount >= 4 {
                    let result = Double(weekTotalWeight) / 1000
                    return String(format: "%.1f", result) + "t"
                } else {
                    return "\(weekTotalWeight)kg"
                }
            }
        } else {
            fatalError("Invalid Report Type")
        }
    }
    
    // 今週と先週の比較用(トータル)
    func fetchComparisonReport(type: Reportable, workoutDays: [WorkoutDay]) -> String {
        guard let type = type as? ReportType else {
            fatalError("Invalid Report Type")
        }
        switch type {
        case .totalSets:
            let thisWeekTotalSetsCount = weekTotalSets(workoutDays: workoutDays)
            let lastWeekTotalSetsCount = weekTotalSets(workoutDays: workoutDays, isThisWeek: false)
            let result = abs(thisWeekTotalSetsCount) - abs(lastWeekTotalSetsCount)
            if thisWeekTotalSetsCount > lastWeekTotalSetsCount {
                return "+ \(result)"
            } else {
                return "- \(result)"
            }
        case .totalReps:
            let thisWeekTotalRepsCount = weekTotalReps(workoutDays: workoutDays)
            let lastWeekTotalRepsCount = weekTotalReps(workoutDays: workoutDays, isThisWeek: false)
            let result = abs(thisWeekTotalRepsCount) - abs(lastWeekTotalRepsCount)
            if thisWeekTotalRepsCount > lastWeekTotalRepsCount {
                return "+ \(result)"
            } else {
                return "- \(result)"
            }
        case .totalLoad:
            let thisWeekTotalLoadCount = weekTotalLoad(workoutDays: workoutDays)
            let lastWeekTotalLoadCount = weekTotalLoad(workoutDays: workoutDays, isThisWeek: false)
            let result = abs(thisWeekTotalLoadCount) - abs(lastWeekTotalLoadCount)
            let symbol = if thisWeekTotalLoadCount > lastWeekTotalLoadCount {
                "+"
            } else {
                "-"
            }
            if result >= 4 {
                let result = Double(result) / 1000
                return symbol + String(format: "%.1f", result) + "t"
            } else {
                return "\(symbol) \(result)kg"
            }
        }
    }
    
    // 棒グラフ用のデータ
    func barMarkData(parts: Parts, workoutDays: [WorkoutDay], timePeriod: TimePeriod) -> [BarMarkReport] {
        
        let currentPeriod: Periodable? = switch timePeriod {
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
        
        let previousPeriod: Periodable? = switch timePeriod {
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
            return []
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
            return currentPeriodBarMarkReports
        }
        let previousPeriodBarMarkReports: [BarMarkReport] = [
            .init(period: previousPeriod, value: previousPeriodTotalSet, category: BarMarkReportCategory.set),
            .init(period: previousPeriod, value: previousPeriodTotalRep, category: BarMarkReportCategory.rep),
            .init(period: previousPeriod, value: previousPeriodTotalLoad, category: BarMarkReportCategory.totalLoad)
        ]
        
        return previousPeriodBarMarkReports + currentPeriodBarMarkReports
    }
    
    // 今週と先週・今月と先月・今年と去年の比較用(部位ごと)
    func getWeekCompareData(value: Int, category: BarMarkReportCategory, workoutDays: [WorkoutDay], parts: Parts, timePeriod: TimePeriod) -> String {
        
        let previousPeriodDates: [Date] = switch timePeriod {
        case .thisWeek:
            Date().lastWeekDates
        case .thisMonth:
            Date().lastMonthDates
        case .thisYear:
            Date().lastYearDates
        default:
            fatalError()
        }
        
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
        
        switch category {
        case .set:
            let symbol = value > previousPeriodTotalSet ? "+" : ""
            return symbol + String(abs(value) - abs(previousPeriodTotalSet))
        case .rep:
            let symbol = value > previousPeriodTotalRep ? "+" : ""
            return symbol + String(abs(value) - abs(previousPeriodTotalRep))
        case .totalLoad:
            let symbol = value > previousPeriodTotalLoad ? "+" : ""
            return symbol + String(abs(value) - abs(previousPeriodTotalLoad))
        }
    }
    
    // 今週のトレーニング回数
    func thisWeekWorkoutCount(workoutDays: [WorkoutDay]) -> Int {
        let thisWeekDates = Date().currentWeekDates
        return workoutDays.filter { workoutDay in
            thisWeekDates.contains { date in
                date.zeroClock == workoutDay.createdAt.zeroClock
            }
        }.count
    }
    
    func showSettingTargetDaysAlertIfNeeded() {
        if !appStorageManager.didShowSettingTargetDays {
            didShowSettingTargetDays = true
            isShowSettingTargetDays.toggle()
        }
    }
}
