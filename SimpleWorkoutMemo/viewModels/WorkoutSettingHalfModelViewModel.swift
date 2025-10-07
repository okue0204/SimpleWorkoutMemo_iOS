//
//  WorkoutSettingHalfModelViewModel.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/08.
//

import Foundation
import SwiftUI
import Observation
import SwiftData

@Observable
class WorkoutSettingHalfModelViewModel {
    
    private var exerciseRepository: ExerciseRepository?
    private var modelContext: ModelContext?
    
    func setContext(context: ModelContext) {
        modelContext = context
        setup()
    }
    
    func setup() {
        exerciseRepository = ExerciseRepositoryImpl(modelContext: modelContext!)
    }
    
    func selectedExercise(exercises: [Exercise], for id: String?) -> Exercise? {
        exercises.first {
            $0.id == id
        }
    }
    
    func updateExercise(_ exercise: Exercise, name: String, workoutType: WorkoutType) {
        exercise.exerciseName = name
        exercise.workoutType = workoutType
        do {
            try exerciseRepository?.save()
        } catch {
            
        }
    }
}
