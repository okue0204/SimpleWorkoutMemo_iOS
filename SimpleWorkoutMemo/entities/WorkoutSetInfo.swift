//
//  WorkoutSetInfo.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/23.
//

import Foundation
import SwiftData

@Model
class WorkoutSetInfo: Identifiable {
    @Attribute(.unique) var id: String = UUID().uuidString
    var weight: String
    var rep: String
    var createdAt: Date = Date()
    @Relationship var workout: Workout
    
    init(weight: String, rep: String, workout: Workout) {
        self.weight = weight
        self.rep = rep
        self.workout = workout
    }
}
