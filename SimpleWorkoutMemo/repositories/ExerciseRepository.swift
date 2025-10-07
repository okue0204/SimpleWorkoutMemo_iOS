//
//  ExerciseRepository.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/27.
//

import Foundation
import SwiftData
import SwiftUI

protocol ExerciseRepository {
    func saveDefaultExercise() throws
    func save() throws
    func insert(_ exercise: Exercise) throws
    func update(_ exercise: Exercise) throws
    func delete(_ exercise: Exercise) throws
}

class ExerciseRepositoryImpl: ExerciseRepository {
    
    @Query private var exercises: [Exercise]
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveDefaultExercise() throws {
        try Exercise.defaultExercises.forEach { exercise in
            try insert(exercise)
        }
    }
    
    func save() throws {
        try modelContext.save()
    }
    
    func insert(_ exercise: Exercise) throws {
        modelContext.insert(exercise)
        try save()
    }
    
    func update(_ exercise: Exercise) throws {
        try modelContext.save()
    }
    
    func delete(_ exercise: Exercise) throws {
        modelContext.delete(exercise)
        try save()
    }
}

class ExerciseRepositoryMock: ExerciseRepository {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveDefaultExercise() throws {
        try Exercise.defaultExercises.forEach { exercise in
            try insert(exercise)
        }
    }
    
    func save() throws {
        
    }
    
    func insert(_ exercise: Exercise) throws {
        
    }
    
    func update(_ exercise: Exercise) throws {
        
    }
    
    func fetch() -> [Exercise] {
        [
            .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルプレス"),
            .init(parts: .chest, workoutType: .freeWeight, exerciseName: "インクラインダンベルプレス"),
            .init(parts: .chest, workoutType: .freeWeight, exerciseName: "デクラインダンベルプレス"),
            .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルフライ"),
            .init(parts: .chest, workoutType: .freeWeight, exerciseName: "インクラインダンベルフライ"),
            .init(parts: .biceps, workoutType: .freeWeight, exerciseName: "ダンベルカール"),
            .init(parts: .biceps, workoutType: .freeWeight, exerciseName: "ハンマーカール"),
            .init(parts: .triceps, workoutType: .freeWeight, exerciseName: "ナローベンチプレス"),
            .init(parts: .triceps, workoutType: .freeWeight, exerciseName: "トライセプスエクステンション"),
            .init(parts: .legs, workoutType: .freeWeight, exerciseName: "スクワット"),
            .init(parts: .legs, workoutType: .freeWeight, exerciseName: "ブルガリアンスクワット"),
            .init(parts: .shoulders, workoutType: .freeWeight, exerciseName: "ダンベルショルダープレス"),
            .init(parts: .shoulders, workoutType: .freeWeight, exerciseName: "アーノルドプレス"),
            .init(parts: .shoulders, workoutType: .freeWeight, exerciseName: "ラテラルレイズ"),
            .init(parts: .shoulders, workoutType: .freeWeight, exerciseName: "リアレイズ")
        ]
    }
    
    func delete(_ exercise: Exercise) {
    
    }
}
