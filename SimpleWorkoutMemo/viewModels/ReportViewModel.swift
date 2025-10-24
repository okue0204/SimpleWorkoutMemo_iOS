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
    
    // 今週と先週の比較用
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
}
