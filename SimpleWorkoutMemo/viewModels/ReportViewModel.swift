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
class ReportViewModel {
    
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
    
    func fetchReport(type: Reportable, workoutDays: [WorkoutDay]) -> String {
        if let reportType = type as? ReportType {
            switch reportType {
            case .totalDays:
                return String(workoutDays.count)
            case .totalSets:
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
            case .totalReps:
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
            case .totalLoad:
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
        } else if let thisWeekReportType = type as? ThisWeekReportType {
            switch thisWeekReportType {
            case .thisWeekTotalSets:
                let weekTotalSetCount = weekTotalSets(workoutDays: workoutDays)
                let totalSetsStringCount = String(weekTotalSetCount).count
                if totalSetsStringCount >= 4 {
                    let result = Double(totalSetsStringCount) / 1000
                    return String(format: "%.1f", result) + "k"
                } else {
                    return String(weekTotalSetCount)
                }
            case .thisWeekTotalReps:
                let weekTotalRepCount = weekTotalReps(workoutDays: workoutDays)
                let totalRepsStringCount = String(weekTotalRepCount).count
                if totalRepsStringCount >= 4 {
                    let result = Double(totalRepsStringCount) / 1000
                    return String(format: "%.1f", result) + "k"
                } else {
                    return String(weekTotalRepCount)
                }
            case .thisWeekTotalLoad:
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
        guard let type = type as? ThisWeekReportType else {
            fatalError("Invalid Report Type")
        }
        switch type {
        case .thisWeekTotalSets:
            let thisWeekTotalSetsCount = weekTotalSets(workoutDays: workoutDays)
            let lastWeekTotalSetsCount = weekTotalSets(workoutDays: workoutDays, isThisWeek: false)
            let result = abs(thisWeekTotalSetsCount) - abs(lastWeekTotalSetsCount)
            if thisWeekTotalSetsCount > lastWeekTotalSetsCount {
                return "+ \(result)"
            } else {
                return "- \(result)"
            }
        case .thisWeekTotalReps:
            let thisWeekTotalRepsCount = weekTotalReps(workoutDays: workoutDays)
            let lastWeekTotalRepsCount = weekTotalReps(workoutDays: workoutDays, isThisWeek: false)
            let result = abs(thisWeekTotalRepsCount) - abs(lastWeekTotalRepsCount)
            if thisWeekTotalRepsCount > lastWeekTotalRepsCount {
                return "+ \(result)"
            } else {
                return "- \(result)"
            }
        case .thisWeekTotalLoad:
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
    func barMarkData(parts: Parts, workoutDays: [WorkoutDay]) -> [BarMarkReport] {
        let thisWeekDates = Date().currentWeekDates
        let lastWeekDates = Date().lastWeekDates
        
        // 今週の部位(仮: 胸)のセット・レップ・総負荷量のデータを取得
        let filteredThisWeekWorkouts = workoutDays.filter { workoutDay in
            thisWeekDates.contains { date in
                date.zeroClock == workoutDay.createdAt.zeroClock
            }
        }.flatMap { workoutDay in
            workoutDay.workouts.filter { workout in
                workout.exercise?.parts == parts
            }
        }
        let thisWeekTotalSet = filteredThisWeekWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.workoutSetInfo.count
        }
        let thisWeekTotalRep = filteredThisWeekWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalRep
        }
        let thisWeekTotalLoad = filteredThisWeekWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalWeight
        }
        
        let thisWeekBarMarkReports: [BarMarkReport] = [
            .init(period: WeekPeriod.thisWeek, value: thisWeekTotalSet, category: BarMarkReportCategory.set),
            .init(period: WeekPeriod.thisWeek, value: thisWeekTotalRep, category: BarMarkReportCategory.rep),
            .init(period: WeekPeriod.thisWeek, value: thisWeekTotalLoad, category: BarMarkReportCategory.totalLoad),
        ]
        
        // 先週の部位(仮: 胸)のセット・レップ・総負荷量のデータを取得
        let filteredLastWeekWorkouts = workoutDays.filter { workoutDay in
            lastWeekDates.contains { date in
                date.zeroClock == workoutDay.createdAt.zeroClock
            }
        }.flatMap { workoutDay in
            workoutDay.workouts.filter { workout in
                workout.exercise?.parts == parts
            }
        }
        let lastWeekTotalSet = filteredLastWeekWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.workoutSetInfo.count
        }
        let lastWeekTotalRep = filteredLastWeekWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalRep
        }
        let lastWeekTotalLoad = filteredLastWeekWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalWeight
        }
        
        let lastWeekBarMarkReports: [BarMarkReport] = [
            .init(period: WeekPeriod.lastWeek, value: lastWeekTotalSet, category: BarMarkReportCategory.set),
            .init(period: WeekPeriod.lastWeek, value: lastWeekTotalRep, category: BarMarkReportCategory.rep),
            .init(period: WeekPeriod.lastWeek, value: lastWeekTotalLoad, category: BarMarkReportCategory.totalLoad),
        ]
        
        return lastWeekBarMarkReports + thisWeekBarMarkReports
    }
    
    // 今週と先週の比較用(部位ごと)
    func getWeekCompareData(value: Int, category: BarMarkReportCategory, workoutDays: [WorkoutDay], parts: Parts) -> String {
        let lastWeekDates = Date().lastWeekDates
        let filteredLastWeekWorkouts = workoutDays.filter { workoutDay in
            lastWeekDates.contains { date in
                date.zeroClock == workoutDay.createdAt.zeroClock
            }
        }.flatMap { workoutDay in
            workoutDay.workouts.filter { workout in
                workout.exercise?.parts == parts
            }
        }
        let lastWeekTotalSet = filteredLastWeekWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.workoutSetInfo.count
        }
        let lastWeekTotalRep = filteredLastWeekWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalRep
        }
        let lastWeekTotalLoad = filteredLastWeekWorkouts.reduce(into: 0) { partialResult, workout in
            partialResult += workout.totalWeight
        }
        
        switch category {
        case .set:
            let symbol = if value > lastWeekTotalSet {
                "+"
            } else {
                lastWeekTotalSet == 0 ? "" : "-"
            }
            return symbol + String(abs(value) - abs(lastWeekTotalSet))
        case .rep:
            let symbol = if value > lastWeekTotalRep {
                "+"
            } else {
                lastWeekTotalRep == 0 ? "" : "-"
            }
            return symbol + String(abs(value) - abs(lastWeekTotalRep))
        case .totalLoad:
            let symbol = if value > lastWeekTotalLoad {
                "+"
            } else {
                lastWeekTotalLoad == 0 ? "" : "-"
            }
            return symbol + String(abs(value) - abs(lastWeekTotalLoad))
        }
    }
    
    // 今週のトレーニング回数
    func thisWeekWorkoutCount(workoutDays: [WorkoutDay]) -> Int {
        let thisWeekDates = Date().currentWeekDates
        let hoge = workoutDays.map { workoutDay in
            DateFormatter.dateToString(workoutDay.createdAt)
        }
        print("+++++ hoge \(hoge)")
        
        let fuga = thisWeekDates.map { date in
            DateFormatter.dateToString(date)
        }
        print("+++++ fuga \(fuga)")
        return workoutDays.filter { workoutDay in
            thisWeekDates.contains { date in
                date.zeroClock == workoutDay.createdAt.zeroClock
            }
        }.count
    }
}
