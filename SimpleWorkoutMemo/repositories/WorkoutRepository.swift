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
    func save(_ workouts: WorkoutDay) throws
    func update() throws
    func fetch(for date: Date?) -> [WorkoutDay]
    func delete(_ workouts: WorkoutDay)
}

class WorkoutRepositoryImpl: WorkoutRepository {
    
    @Query private var workoutDays: [WorkoutDay]
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save(_ workoutDay: WorkoutDay) throws {
        modelContext.insert(workoutDay)
        try modelContext.save()
    }
    
    func update() throws {
        try modelContext.save()
    }
    
    func fetch(for date: Date?) -> [WorkoutDay] {
        workoutDays
    }
    
    func delete(_ workoutDay: WorkoutDay) {
        modelContext.delete(workoutDay)
    }
}

class WorkoutRepositoryMock: WorkoutRepository {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save(_ workoutDay: WorkoutDay) {
        
    }
    
    func update() throws {
        
    }
    
    func fetch(for date: Date?) -> [WorkoutDay] {
        [
            .init(createdAt: Date().zeroClock, workouts:
                    [
                        .init(exercise: .init(parts: .chest,
                                              workoutType: .freeWeight,
                                              exerciseName: "ダンベルプレス"),
                              workoutSetInfo: [
                                .init(weight: "30", rep: "10"),
                                .init(weight: "30", rep: "8"),
                                .init(weight: "30", rep: "6"),
                                .init(weight: "30", rep: "5")
                              ]),
                        .init(exercise: .init(parts: .chest,
                                              workoutType: .freeWeight,
                                              exerciseName: "ダンベルフライ"),
                              workoutSetInfo: [
                                .init(weight: "12", rep: "14"),
                                .init(weight: "12", rep: "12"),
                                .init(weight: "10", rep: "15"),
                                .init(weight: "10", rep: "10")
                              ]),
                        .init(exercise: .init(parts: .chest,
                                              workoutType: .machine,
                                              exerciseName: "ペックフライ"),
                              workoutSetInfo: [
                                .init(weight: "30", rep: "10"),
                                .init(weight: "30", rep: "8"),
                                .init(weight: "30", rep: "6"),
                                .init(weight: "30", rep: "5"),
                                .init(weight: "28", rep: "8")
                              ]),
                        .init(exercise: .init(parts: .back,
                                              workoutType: .machine,
                                              exerciseName: "チンニング"),
                              workoutSetInfo: [
                                .init(weight: "", rep: "10"),
                                .init(weight: "", rep: "8"),
                                .init(weight: "", rep: "6")
                              ]),
                    ]),
            .init(createdAt: Date().addDay(1), workouts: [
                .init(exercise: .init(parts: .shoulders,
                                      workoutType: .freeWeight,
                                      exerciseName: "ダンベルショルダープレス"),
                      workoutSetInfo: [
                        .init(weight: "30", rep: "14"),
                        .init(weight: "30", rep: "12"),
                        .init(weight: "30", rep: "10"),
                        .init(weight: "30", rep: "8"),
                        .init(weight: "30", rep: "6"),
                        .init(weight: "30", rep: "5"),
                      ]),
                .init(exercise: .init(parts: .shoulders,
                                      workoutType: .freeWeight,
                                      exerciseName: "ラテラルレイズ"),
                      workoutSetInfo: [
                        .init(weight: "14", rep: "14"),
                        .init(weight: "14", rep: "12"),
                        .init(weight: "14", rep: "10"),
                        .init(weight: "14", rep: "8"),
                        .init(weight: "10", rep: "10"),
                        .init(weight: "10", rep: "9"),
                      ]),
                .init(exercise: .init(parts: .shoulders,
                                      workoutType: .freeWeight,
                                      exerciseName: "ライイングリアレイズ"),
                      workoutSetInfo: [
                        .init(weight: "8", rep: "14"),
                        .init(weight: "8", rep: "12"),
                        .init(weight: "8", rep: "10"),
                        .init(weight: "8", rep: "8")
                      ]),
            ])
        ]
    }
    
    func delete(_ workouts: WorkoutDay) {
        
    }
}
