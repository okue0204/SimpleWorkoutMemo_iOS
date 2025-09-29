//
//  Workout.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/23.
//

import Foundation
import SwiftData

@Model
class Workout: Identifiable {
    var id = UUID().uuidString
    var exercise: Exercise
    var workoutSetInfo: [WorkoutSetInfo]
    
    init(exercise: Exercise, workoutSetInfo: [WorkoutSetInfo]) {
        self.exercise = exercise
        self.workoutSetInfo = workoutSetInfo
    }
}
