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
    func saveDefaultExercise()
    func save(_ exercise: Exercise)
    func update(_ exercise: Exercise) throws
    func delete(_ exercise: Exercise)
}

class ExerciseRepositoryImpl: ExerciseRepository {
    
    @Query private var exercises: [Exercise]
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveDefaultExercise() {
        Exercise.defaultExercises.forEach { exercise in
            save(exercise)
        }
    }
    
    func save(_ exercise: Exercise) {
        modelContext.insert(exercise)
    }
    
    func update(_ exercise: Exercise) throws {
        try modelContext.save()
    }
    
    func delete(_ exercise: Exercise) {
        modelContext.delete(exercise)
    }
}

class ExerciseRepositoryMock: ExerciseRepository {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveDefaultExercise() {
        Exercise.defaultExercises.forEach { exercise in
            save(exercise)
        }
    }
    
    func save(_ exercise: Exercise) {
        
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
