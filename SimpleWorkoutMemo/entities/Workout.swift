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
    var exercise: Exercise
    @Relationship(deleteRule: .cascade, inverse: \WorkoutSetInfo.workout)
    var workoutSetInfo: [WorkoutSetInfo] = []
    
    init(exercise: Exercise, workoutSetInfo: [WorkoutSetInfo] = []) {
        self.exercise = exercise
        self.workoutSetInfo = workoutSetInfo
    }
    
    var sortedWorkoutSetInfo: [WorkoutSetInfo] {
        workoutSetInfo.sorted { $0.createdAt < $1.createdAt }
    }
}
