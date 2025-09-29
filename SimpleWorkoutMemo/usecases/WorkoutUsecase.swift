//
//  WorkoutUsecase.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/26.
//

import Foundation

class WorkoutUsecase {
    
    private let repository: WorkoutRepository
    
    init(repository: WorkoutRepository) {
        self.repository = repository
    }
    
    func save(_ workoutDay: WorkoutDay) throws {
        try repository.save(workoutDay)
    }
    
    func update() throws {
        try repository.update()
    }
    
    func fetch(for date: Date? = nil) -> [WorkoutDay] {
        repository.fetch(for: date?.zeroClock)
    }
    
    func delete(_ workouts: WorkoutDay) {
        
    }
}
