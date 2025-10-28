//
//  Workout.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/23.
//

import Foundation
import SwiftData

@Model
class Workout: Identifiable, ObservableObject {
    @Attribute(.unique) var id: String = UUID().uuidString
    @Relationship var exercise: Exercise?
    @Relationship(deleteRule: .cascade, inverse: \WorkoutSetInfo.workout)
    var workoutSetInfo: [WorkoutSetInfo] = []
    
    init(exercise: Exercise, workoutSetInfo: [WorkoutSetInfo] = []) {
        self.exercise = exercise
        self.workoutSetInfo = workoutSetInfo
    }
    
    var sortedWorkoutSetInfo: [WorkoutSetInfo] {
        workoutSetInfo.sorted { $0.createdAt < $1.createdAt }
    }
    
    var maxWeight: Double {
        let result = workoutSetInfo.compactMap { setInfo in
            Double(setInfo.weight)
        }.sorted { rhs, lhs in
            rhs > lhs
        }.first ?? 0
        return round(result * 10) / 10
    }
    
    var totalWeightString: String {
        let totalWeight = workoutSetInfo.reduce(into: 0) { partialResult, workoutSetInfo in
            partialResult += (Double(workoutSetInfo.rep) ?? 0) * (Double(workoutSetInfo.weight) ?? 0)
        }
        return String(Int(totalWeight))
    }
    
    var totalRepString: String {
        let totalRep = workoutSetInfo.reduce(into: 0) { partialResult, setInfo in
            partialResult += Int(setInfo.rep) ?? 0
        }
        return String(totalRep)
    }
    
    var totalWeight: Int {
        let totalWeight = workoutSetInfo.reduce(into: 0) { partialResult, workoutSetInfo in
            partialResult += (Double(workoutSetInfo.rep) ?? 0) * (Double(workoutSetInfo.weight) ?? 0)
        }
        return Int(totalWeight)
    }
    
    var totalRep: Int {
        let totalRep = workoutSetInfo.reduce(into: 0) { partialResult, setInfo in
            partialResult += Int(setInfo.rep) ?? 0
        }
        return totalRep
    }
    
    func differenceWeight(previousWorkout: Workout) -> String {
        return if totalWeight > previousWorkout.totalWeight {
            "重量 : + \(abs(totalWeight - previousWorkout.totalWeight))"
        } else {
            "重量 : - \(abs(totalWeight - previousWorkout.totalWeight))"
        }
    }
    
    func differenceRep(previousWorkout: Workout) -> String {
        return if totalRep > previousWorkout.totalRep {
            "回数 : + \(abs(totalRep - previousWorkout.totalRep))回"
        } else {
            "回数 : - \(abs(totalRep - previousWorkout.totalRep))回"
        }
    }
}
