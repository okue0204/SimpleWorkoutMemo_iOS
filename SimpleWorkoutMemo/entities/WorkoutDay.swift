//
//  WrokoutDay.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/27.
//

import Foundation
import SwiftData

@Model
class WorkoutDay: Identifiable {
    var id = UUID().uuidString
    var createdAt: Date = Date()
    @Relationship(deleteRule: .cascade) var workouts: [Workout]
    
    init(id: String = UUID().uuidString, createdAt: Date, workouts: [Workout]) {
        self.id = id
        self.createdAt = createdAt
        self.workouts = workouts
    }
}
