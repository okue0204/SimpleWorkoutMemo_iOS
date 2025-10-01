//
//  HomeViewModel.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/25.
//

import Foundation
import SwiftUI
import Observation
import SwiftData

@Observable
class HomeViewModel {
    
    var workoutDays: [WorkoutDay] = []
    var exercises: [Exercise] = []
    
    // error
    var onFailureWorkoutUpdate: Bool = false
    var onFailureExericesUpdate: Bool = false
    var onFailureWorkoutSave: Bool = false
    
    private var workoutRepository: WorkoutRepository?
    private var exerciseRepository: ExerciseRepository?
    private var modelContext: ModelContext?
    
    func setContext(context: ModelContext) {
        modelContext = context
        setup()
    }
    
    func setup() {
        workoutRepository = WorkoutRepositoryImpl(modelContext: modelContext!)
        exerciseRepository = ExerciseRepositoryImpl(modelContext: modelContext!)
    }
    
    // MARK: - workout
    func save(_ workoutDay: WorkoutDay?) {
        guard let workoutDay, let workoutRepository else {
            return
        }
        do {
            try workoutRepository.insert(workoutDay)
        } catch {
            onFailureWorkoutSave.toggle()
        }
    }
    
    func update(workout: Workout, with setInfo: WorkoutSetInfo, at index: Int) {
        guard let workoutRepository else { return }
        do {
            if let index = workout.workoutSetInfo.firstIndex(where: { info in
                info.id == setInfo.id
            }) {
                workout.workoutSetInfo[index] = setInfo
            }
            try workoutRepository.save()
        } catch {
            
        }
    }
    
    func fetch(for date: Date? = nil) {
        guard let workoutRepository else { return }
        workoutDays = workoutRepository.fetch(for: date)
    }
    
    func delete(_ workoutDay: WorkoutDay) {
        guard let workoutRepository else { return }
        do {
            try workoutRepository.delete(workoutDay)
        } catch {
            
        }
    }
    
    func addWorkout(_ workout: Workout, date: Date = Date()) {
        let setInfo = WorkoutSetInfo(weight: "", rep: "", workout: workout)
        workout.workoutSetInfo.append(setInfo)
        let workoutDay = WorkoutDay(createdAt: date, workouts: [workout])
        save(workoutDay)
    }
    
    func removeWorkout(_ workoutDay: WorkoutDay, at index: Int) {
        do {
            let removeWorkout = workoutDay.workouts[index]
            try workoutRepository?.delete(removeWorkout)
        } catch {
            
        }
    }
    
    func addSetInfo(_ workoutDay: WorkoutDay, at workoutIndex: Int) {
        guard let workoutRepository else { return }
        let workoutSetInfo = WorkoutSetInfo(weight: "", rep: "", workout: workoutDay.workouts[workoutIndex])
        workoutDay.workouts[workoutIndex].workoutSetInfo.append(workoutSetInfo)
        do {
            try workoutRepository.save()
        } catch {
            
        }
    }
    
    func removeSetInfo(workoutDay: WorkoutDay, at workoutIndex: Int) {
        guard let workoutRepository, let removeSetInfo = workoutDay.workouts[workoutIndex].sortedWorkoutSetInfo.last else { return }
        do {
            try workoutRepository.delete(removeSetInfo)
        } catch {
            
        }
    }
    
    // MARK: - exercise
    func saveDefaultExercise() {
        guard let exerciseRepository else { return }
        exerciseRepository.saveDefaultExercise()
    }
    
    func save(_ exercise: Exercise) {
        guard let exerciseRepository else { return }
        exerciseRepository.save(exercise)
    }
    
    func update(_ exercise: Exercise) throws {
        guard let exerciseRepository else { return }
        do {
            try exerciseRepository.update(exercise)
        } catch {
            onFailureExericesUpdate.toggle()
        }
    }
    
    func delete(_ exercise: Exercise) {
        
    }
}
