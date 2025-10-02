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
    var totalWeight: String = "0"
    
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
    func save() {
        guard let workoutRepository else {
            return
        }
        do {
            try workoutRepository.save()
        } catch {
            onFailureWorkoutSave.toggle()
        }
    }
    
    func insert(_ workoutDay: WorkoutDay) {
        guard let workoutRepository else {
            return
        }
        do {
            try workoutRepository.insert(workoutDay)
        } catch {
            
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
    
    func addWorkout(_ workoutDays: [WorkoutDay], exercise: Exercise, date: Date = Date()) {
        if let todayWorkoutDay = workoutDays.first(where: { workoutDay in
            workoutDay.createdAt.zeroClock == Date().zeroClock
        }) {
            let newWorkout = Workout(exercise: exercise)
            todayWorkoutDay.workouts.append(newWorkout)
            let setInfo = WorkoutSetInfo(weight: "", rep: "", workout: newWorkout)
            newWorkout.workoutSetInfo.append(setInfo)
            save()
        } else {
            let newWorkout = Workout(exercise: exercise)
            let newWorkoutDay = WorkoutDay(createdAt: Date(), workouts: [newWorkout])
            let setInfo = WorkoutSetInfo(weight: "", rep: "", workout: newWorkout)
            newWorkout.workoutSetInfo.append(setInfo)
            insert(newWorkoutDay)
        }
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
    
    func calculateTotalWeight(workoutDay: WorkoutDay) {
        let workoutSetInfo = workoutDay.workouts.flatMap { workout in
            workout.workoutSetInfo
        }
        let totalWeight = workoutSetInfo.reduce(into: 0) { partialResult, workoutSetInfo in
            partialResult += (Double(workoutSetInfo.rep) ?? 0) * (Double(workoutSetInfo.weight) ?? 0)
        }
        self.totalWeight = String(format: "%.1f", totalWeight)
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
