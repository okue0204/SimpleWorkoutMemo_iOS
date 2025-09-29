//
//  ExerciseUsecase.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/27.
//

import Foundation

class ExerciseUsecase {
    
    private let repository: ExerciseRepository
    
    init(repository: ExerciseRepository) {
        self.repository = repository
    }
    
    func saveDefaultExercise() {
        Exercise.defaultExercises.forEach { exercise in
            repository.save(exercise)
        }
    }
    
    func save(exercise: Exercise) {
        repository.save(exercise)
    }
    
    func update(exercise: Exercise) throws {
        try repository.update(exercise)
    }
    
    func delete(exercise: Exercise) {
        repository.delete(exercise)
    }
}
