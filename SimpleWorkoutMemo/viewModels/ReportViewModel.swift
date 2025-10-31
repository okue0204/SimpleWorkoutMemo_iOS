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
