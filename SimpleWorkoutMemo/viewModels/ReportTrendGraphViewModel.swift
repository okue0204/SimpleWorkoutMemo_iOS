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
    
    private let mock: [LineMarkReport] = (0..<800).map { num in
        .init(
            value: Double.random(in: 0...30),
            createdAt: Date().addAndSubtractDay(num).zeroClock
        )
    }
    
    var minLineMarkValue: Double = 0
    var maxLineMarkValue: Double = 0
    var firstLineMarkDate: Date = Date()
    var lastLineMarkDate: Date = Date()
    var lineMarkData: [LineMarkReport] = []
    var uniqueYears: [Int] = []
    
    private func roundUp(toMultipleOf multiple: Double) -> Double {
        /*
         グラフの都合上最大値から一番近い偶数値に合わせる
         例: 48 → 60
         単位を20に設定
         */
        let digitCount = String(Int(multiple)).count
        let unit = Double(digitCount == 3 ? 50 : 20)
        let ceil = ceil(multiple / unit)
        if digitCount < 3 {
            return ceil * unit
        } else {
            return multiple * 2
        }
    }
    
    // 種目別最大重量の推移 or 部位別トータルボリュームの推移
    func lineMarkData(exercise: Exercise, volumeType: VolumeType, workoutDays: [WorkoutDay], targetYear: Int) {
        switch volumeType {
        case .maxVolume:
            let lineMark = workoutDays.flatMap { workoutDay in
                workoutDay.workouts.filter { workout in
                    workout.exercise?.id == exercise.id
                }.map { workout in
                    LineMarkReport(value: workout.maxWeight, createdAt: workoutDay.createdAt.zeroClock)
                }
            }.filter { report in
                // 1年間分のみ取得
                let value = targetYear - Date().year
                return Date.yearRange(for: value).contains(report.createdAt)
            }
            
            let hoge = mock.filter { report in
                let value = targetYear - Date().year
                return Date.yearRange(for: value).contains(report.createdAt)
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
        firstLineMarkDate = dates.min() ?? Date()
        lastLineMarkDate = dates.max() ?? Date()
    }
    
    func uniqueWorkoutYears(exercise: Exercise, workoutDays: [WorkoutDay]) {
        let filteredWorkoutDays = workoutDays.filter { workoutDay in
            workoutDay.workouts.contains { workout in
                workout.exercise?.id == exercise.id
            }
        }
        let years = Set(
            filteredWorkoutDays.compactMap { data in
                data.createdAt.year
            }
        ).sorted()
        uniqueYears = years.isEmpty ? [Date().year] : years
    }
}
