//
//  ReportTrendGraphViewModel.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/28.
//

import Foundation
import SwiftUI
import Observation

@Observable
class ReportTrendGraphViewModel {
    
    let mock: [LineMarkReport] = [
        .init(value: 30, createdAt: Date().zeroClock),
        .init(value: 32, createdAt: Date().addAndSubtractDay(1).zeroClock),
        .init(value: 34, createdAt: Date().addAndSubtractDay(2).zeroClock),
        .init(value: 36, createdAt: Date().addAndSubtractDay(3).zeroClock),
        .init(value: 38, createdAt: Date().addAndSubtractDay(4).zeroClock),
        .init(value: 40, createdAt: Date().addAndSubtractDay(5).zeroClock),
        .init(value: 42, createdAt: Date().addAndSubtractDay(6).zeroClock),
        .init(value: 44, createdAt: Date().addAndSubtractDay(7).zeroClock),
        .init(value: 46, createdAt: Date().addAndSubtractDay(8).zeroClock),
        .init(value: 48, createdAt: Date().addAndSubtractDay(9).zeroClock),
        .init(value: 30, createdAt: Date().addAndSubtractDay(10).zeroClock),
        .init(value: 28, createdAt: Date().addAndSubtractDay(11).zeroClock),
        .init(value: 40, createdAt: Date().addAndSubtractDay(12).zeroClock),
        .init(value: 40, createdAt: Date().addAndSubtractDay(13).zeroClock),
        .init(value: 40, createdAt: Date().addAndSubtractDay(14).zeroClock),
        .init(value: 50, createdAt: Date().addAndSubtractDay(15).zeroClock),
    ]
    
    var minLineMarkValue: Double = 0
    var maxLineMarkValue: Double = 0
    var firstLineMarkDate: Date = Date()
    var lastLineMarkDate: Date = Date()
    var lineMarkData: [LineMarkReport] = []
    var exercises: [Exercise] = []
    
    private func roundUp(toMultipleOf multiple: Double) -> Double {
        /*
         グラフの都合上最大値から一番近い偶数値に合わせる
         例: 48 → 60
         単位を20に設定
         */
        let n: Double = 20
        let ceil = ceil(multiple / n)
        return ceil * n
    }
    
    // 部位別のexerciseの数を取得
    func fetchExercise(for parts: Parts, exercises: [Exercise]) {
        let exercises = exercises.filter { execise in
            execise.parts.id == parts.id
        }
        self.exercises = exercises
    }
    
    // 種目別最大重量の推移 or 部位別トータルボリュームの推移
    func lineMarkData(exercise: Exercise, volumeType: VolumeType, workoutDays: [WorkoutDay]) {
        switch volumeType {
        case .maxVolume:
            let lineMark = workoutDays.flatMap { workoutDay in
                workoutDay.workouts.filter { workout in
                    workout.exercise?.id == exercise.id
                }.map { workout in
                    LineMarkReport(value: workout.maxWeight, createdAt: workoutDay.createdAt.zeroClock)
                }
            }
            lineMarkData = lineMark
        case .totalVolume:
            break
        }
    }
    
    // 推移グラフで選択している最大重量
    func selectedLineMarkValue(for selectedDate: Date) -> Double {
        lineMarkData.first { report in
            report.createdAt.zeroClock == selectedDate.zeroClock
        }?.value ?? 0
    }
    
    func minAndMaxValue() {
        let values = lineMarkData.map { $0.value }
        minLineMarkValue = values.min() ?? 0
        maxLineMarkValue = roundUp(toMultipleOf: values.max() ?? 0)
    }
    
    func firstAndLastLineMarkDate() {
        let dates = lineMarkData.map { $0.createdAt }
        firstLineMarkDate = dates.first ?? Date()
        lastLineMarkDate = dates.last ?? Date()
    }
}
