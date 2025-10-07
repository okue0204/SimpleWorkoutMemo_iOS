//
//  WorkoutRepository.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/26.
//

import Foundation
import SwiftData
import SwiftUI

protocol WorkoutRepository {
    func save() throws
    func insert(_ workouts: WorkoutDay) throws
    func delete(_ workouts: WorkoutDay) throws
    func delete(_ workout: Workout) throws
    func delete(_ workoutSetInfo: WorkoutSetInfo) throws
}

class WorkoutRepositoryImpl: WorkoutRepository {
    
    @Query private var workoutDays: [WorkoutDay]
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save() throws {
        try modelContext.save()
    }
    
    func insert(_ workoutDay: WorkoutDay) throws {
        modelContext.insert(workoutDay)
        try save()
    }
    
    func delete(_ workoutDay: WorkoutDay) throws {
        modelContext.delete(workoutDay)
        try save()
    }
    
    func delete(_ workout: Workout) throws {
        modelContext.delete(workout)
        try save()
    }
    
    func delete(_ workoutSetInfo: WorkoutSetInfo) throws {
        modelContext.delete(workoutSetInfo)
        try save()
    }
}

class WorkoutRepositoryMock: WorkoutRepository {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save() throws {
        
    }
    
    func insert(_ workouts: WorkoutDay) throws {
        
    }
    
    func delete(_ workouts: WorkoutDay) throws {
        
    }
    
    func delete(_ workout: Workout) throws {
        
    }
    
    func delete(_ workoutSetInfo: WorkoutSetInfo) throws {
        
    }
}
