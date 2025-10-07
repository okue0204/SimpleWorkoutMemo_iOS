//
//  SelectWorkoutMenuViewModel.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/07.
//

import Foundation
import SwiftUI
import Observation
import SwiftData

@Observable
class WorkoutListViewModel {
    
    private var exerciseRepository: ExerciseRepository?
    private var modelContext: ModelContext?
    
    func setContext(context: ModelContext) {
        modelContext = context
        setup()
    }
    
    func setup() {
        exerciseRepository = ExerciseRepositoryImpl(modelContext: modelContext!)
    }
    
    func addExercise(_ exercise: Exercise) {
        guard let exerciseRepository else { return }
        do {
            try exerciseRepository.insert(exercise)
        } catch {
            
        }
    }
    
    func delete(_ exercise: Exercise) {
        guard let exerciseRepository else { return }
        do {
            try exerciseRepository.delete(exercise)
        } catch {
            
        }
    }
}
