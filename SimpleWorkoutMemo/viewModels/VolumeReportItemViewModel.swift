//
//  VolumeReportItemViewModel.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/28.
//

import Foundation
import SwiftUI
import Observation

@Observable
class VolumeReportItemViewModel {
    var exercises: [Exercise] = []
    var totalVolume: String = ""
    
    func fetchExercise(for parts: Parts, exercises: [Exercise]) {
        let exercises = exercises.filter { execise in
            execise.parts.id == parts.id
        }
        self.exercises = exercises
    }
    
    func fetchTotalVolume(for parts: Parts, workoutDays: [WorkoutDay]) {
        let allTotalVolume = workoutDays.reduce(into: 0) { partialResult, workoutDay in
            let filteredWorkouts = workoutDay.workouts.filter { workout in
                workout.exercise?.parts.id == parts.id
            }
            let totalVolume = filteredWorkouts.reduce(into: 0) { partialResult, workout in
                let result = workout.workoutSetInfo.reduce(into: 0) { partialResult, setInfo in
                    if let weight = Double(setInfo.weight), let rep = Double(setInfo.rep) {
                        partialResult += weight * rep
                    } else {
                        partialResult += 0
                    }
                }
                partialResult += result
            }
            return partialResult += totalVolume
        }
        
        if allTotalVolume >= 4 {
            let result = Double(allTotalVolume) / 1000
            totalVolume = String(format: "%.1f", result) + "t"
        } else {
            if Int(allTotalVolume) == 0 {
                totalVolume = "\(0)kg"
            } else {
                totalVolume = "\(allTotalVolume)kg"
            }
        }
    }
}
