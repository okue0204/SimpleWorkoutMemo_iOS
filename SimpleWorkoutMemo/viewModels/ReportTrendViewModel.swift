//
//  ReportTrendViewModel.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/28.
//

import Foundation
import SwiftUI
import Observation

@Observable
class ReportTrendViewModel {
    
    var exercises: [Exercise] = []
    
    // 部位別のexerciseの数を取得
    func fetchExercise(for parts: Parts, exercises: [Exercise]) {
        let exercises = exercises.filter { execise in
            execise.parts.id == parts.id
        }
        self.exercises = exercises
    }
}
