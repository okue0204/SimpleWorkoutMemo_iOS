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
    
    var todayWorkoutDay: WorkoutDay?
    var filteredExercises: [Exercise] = []
    
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
    
    func setTodayWorkout(workoutDays: [WorkoutDay]) {
        let workoutDay = workoutDays.first { workoutDay in
            workoutDay.createdAt.zeroClock == Date().zeroClock
        }
        todayWorkoutDay = workoutDay
    }
    
    func delete(for workoutDay: WorkoutDay) {
        guard let workoutRepository else { return }
        do {
            try workoutRepository.delete(workoutDay)
        } catch {
            
        }
    }
    
    func addWorkout(_ workoutDays: [WorkoutDay], exercise: Exercise) {
        if let todayWorkoutDay = workoutDays.first(where: { workoutDay in
            workoutDay.createdAt.zeroClock == Date().zeroClock
        }) {
            let newWorkout = Workout(exercise: exercise)
            todayWorkoutDay.workouts.append(newWorkout)
            let setInfo = WorkoutSetInfo(weight: "", rep: "", workout: newWorkout)
            newWorkout.workoutSetInfo.append(setInfo)
            save()
            setTodayWorkout(workoutDays: workoutDays)
        } else {
            let newWorkout = Workout(exercise: exercise)
            let newWorkoutDay = WorkoutDay(createdAt: Date(), workouts: [newWorkout])
            let setInfo = WorkoutSetInfo(weight: "", rep: "", workout: newWorkout)
            newWorkout.workoutSetInfo.append(setInfo)
            insert(newWorkoutDay)
            todayWorkoutDay = newWorkoutDay
        }
    }
    
    func removeWorkout(_ workoutDay: WorkoutDay, at index: Int) {
        guard let workoutRepository else { return }
        do {
            let removeWorkout = workoutDay.workouts[index]
            workoutDay.workouts.remove(at: index)
            try workoutRepository.delete(removeWorkout)
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
        do {
            try exerciseRepository.saveDefaultExercise()
        } catch {
            
        }
    }
    
    func save(_ exercise: Exercise) {
        guard let exerciseRepository else { return }
        do {
            try exerciseRepository.save()
        } catch {
            
        }
    }
    
    func update(_ exercise: Exercise) throws {
        guard let exerciseRepository else { return }
        do {
            try exerciseRepository.update(exercise)
        } catch {
            onFailureExericesUpdate.toggle()
        }
    }
    
    func filter(for exercises: [Exercise]) {
        if let todayWorkoutDay {
            let exercises = exercises.filter { exercise in
                !todayWorkoutDay.workouts.contains { workout in
                    workout.exercise?.id == exercise.id
                }
            }
            filteredExercises = exercises
        } else {
            filteredExercises = exercises
        }
    }
}
