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
    func fetch(for date: Date?) -> [WorkoutDay]
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
    
    func fetch(for date: Date?) -> [WorkoutDay] {
        workoutDays
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
    
    func fetch(for date: Date?) -> [WorkoutDay] {
        [
            .init(createdAt: Date().zeroClock, workouts:
                    [
                        .init(exercise: .init(parts: .chest,
                                              workoutType: .freeWeight,
                                              exerciseName: "ダンベルプレス"),
                              workoutSetInfo: [
                                .init(weight: "30", rep: "10",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルプレス"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "8",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルプレス"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "6",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルプレス"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "4",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルプレス"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "4",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルプレス"),
                                                     workoutSetInfo: []))
                              ]),
                        .init(exercise: .init(parts: .chest,
                                              workoutType: .freeWeight,
                                              exerciseName: "ダンベルフライ"),
                              workoutSetInfo: [
                                .init(weight: "30", rep: "10",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルフライ"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "8",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルフライ"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "6",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルフライ"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "4",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルフライ"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "4",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルフライ"),
                                                     workoutSetInfo: []))
                              ]),
                        .init(exercise: .init(parts: .chest,
                                              workoutType: .machine,
                                              exerciseName: "ペックフライ"),
                              workoutSetInfo: [
                                .init(weight: "30", rep: "10",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ペックフライ"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "8",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ペックフライ"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "6",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルプレス"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "4",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ペックフライ"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "4",
                                      workout: .init(exercise: .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ペックフライ"),
                                                     workoutSetInfo: []))
                              ]),
                        .init(exercise: .init(parts: .back,
                                              workoutType: .freeWeight,
                                              exerciseName: "チンニング"),
                              workoutSetInfo: [
                                .init(weight: "30", rep: "10",
                                      workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "8",
                                      workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "6",
                                      workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "4",
                                      workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                                     workoutSetInfo: [])),
                                .init(weight: "30", rep: "4",
                                      workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                                     workoutSetInfo: []))
                              ]),
                    ]),
            .init(createdAt: Date().addAndSubtractDay(1), workouts: [
                .init(exercise: .init(parts: .shoulders,
                                      workoutType: .freeWeight,
                                      exerciseName: "ダンベルショルダープレス"),
                      workoutSetInfo: [
                        .init(weight: "30", rep: "10",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "8",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "6",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "4",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "4",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: []))
                      ]),
                .init(exercise: .init(parts: .shoulders,
                                      workoutType: .freeWeight,
                                      exerciseName: "ラテラルレイズ"),
                      workoutSetInfo: [
                        .init(weight: "30", rep: "10",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "8",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "6",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "4",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "4",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: []))
                      ]),
                .init(exercise: .init(parts: .shoulders,
                                      workoutType: .freeWeight,
                                      exerciseName: "ライイングリアレイズ"),
                      workoutSetInfo: [
                        .init(weight: "30", rep: "10",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "8",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "6",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "4",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: [])),
                        .init(weight: "30", rep: "4",
                              workout: .init(exercise: .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
                                             workoutSetInfo: []))
                      ]),
            ])
        ]
    }
    
    func delete(_ workouts: WorkoutDay) throws {
        
    }
    
    func delete(_ workout: Workout) throws {
        
    }
    
    func delete(_ workoutSetInfo: WorkoutSetInfo) throws {
        
    }
}
