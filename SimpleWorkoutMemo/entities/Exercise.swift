//
//  Exercise.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/26.
//

import Foundation
import SwiftData

@Model
class Exercise: Identifiable {
    var id = UUID().uuidString
    var parts: Parts
    var workoutType: WorkoutType
    var exerciseName: String
    
    init(id: String = UUID().uuidString, parts: Parts, workoutType: WorkoutType, exerciseName: String) {
        self.id = id
        self.parts = parts
        self.workoutType = workoutType
        self.exerciseName = exerciseName
    }
}

extension Exercise {
    static var defaultExercises: [Exercise] {
        [
            .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルプレス"),
            .init(parts: .chest, workoutType: .freeWeight, exerciseName: "インクラインダンベルプレス"),
            .init(parts: .chest, workoutType: .freeWeight, exerciseName: "デクラインダンベルプレス"),
            .init(parts: .chest, workoutType: .freeWeight, exerciseName: "ダンベルフライ"),
            .init(parts: .chest, workoutType: .freeWeight, exerciseName: "インクラインダンベルフライ"),
            .init(parts: .chest, workoutType: .machine, exerciseName: "ペックフライ"),
            .init(parts: .biceps, workoutType: .freeWeight, exerciseName: "ダンベルカール"),
            .init(parts: .biceps, workoutType: .freeWeight, exerciseName: "ハンマーカール"),
            .init(parts: .triceps, workoutType: .freeWeight, exerciseName: "ナローベンチプレス"),
            .init(parts: .triceps, workoutType: .freeWeight, exerciseName: "トライセプスエクステンション"),
            .init(parts: .legs, workoutType: .freeWeight, exerciseName: "スクワット"),
            .init(parts: .legs, workoutType: .machine, exerciseName: "レッグプレス"),
            .init(parts: .legs, workoutType: .freeWeight, exerciseName: "ブルガリアンスクワット"),
            .init(parts: .shoulders, workoutType: .freeWeight, exerciseName: "ダンベルショルダープレス"),
            .init(parts: .shoulders, workoutType: .freeWeight, exerciseName: "アーノルドプレス"),
            .init(parts: .shoulders, workoutType: .freeWeight, exerciseName: "ラテラルレイズ"),
            .init(parts: .shoulders, workoutType: .freeWeight, exerciseName: "リアレイズ"),
            .init(parts: .back, workoutType: .freeWeight, exerciseName: "デッドリフト"),
            .init(parts: .back, workoutType: .freeWeight, exerciseName: "チンニング"),
            .init(parts: .back, workoutType: .machine, exerciseName: "ラットプルダウン"),
            .init(parts: .back, workoutType: .freeWeight, exerciseName: "ベントオーバーロー"),
            .init(parts: .abs, workoutType: .freeWeight, exerciseName: "腹筋")
        ]
    }
}
