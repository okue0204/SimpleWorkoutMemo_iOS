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
    var isShowUpdateAlert: Bool = false
    var didAddWorkout: Bool = false
    
    // error
    var onFailureWorkoutUpdate: Bool = false
    var onFailureExericesUpdate: Bool = false
    var onFailureWorkoutSave: Bool = false
    
    private let appStorageManager = AppStorageManager.shared
    private var workoutRepository: WorkoutRepository?
    private var exerciseRepository: ExerciseRepository?
    private var modelContext: ModelContext?
    private var shouldShowUpdateAlert = true
    
    func setContext(context: ModelContext) {
        modelContext = context
        setup()
    }
    
    func setup() {
        workoutRepository = WorkoutRepositoryImpl(modelContext: modelContext!)
        exerciseRepository = ExerciseRepositoryImpl(modelContext: modelContext!)
    }
    
    func fetchPreviousWorkout(workoutDays: [WorkoutDay], todayWorkout: Workout) -> Workout? {
        let filterWorkoutDays = workoutDays.filter { workoutDay in
            workoutDay.createdAt.zeroClock != Date().zeroClock
        }
        let previousWorkoutDay = filterWorkoutDays.first { workoutDay in
            workoutDay.workouts.contains { workout in
                workout.exercise?.exerciseName == todayWorkout.exercise?.exerciseName
            }
        }
        return previousWorkoutDay?.workouts.first { workout in
            workout.exercise?.id == todayWorkout.exercise?.id
        }
    }
    
    // MARK: - AppStorage
    func incrementLaunchCount() {
        appStorageManager.appLaunchCount += 1
    }
    
    func resetLastAppLaunch() {
        appStorageManager.isShowLastTimeAppLaunch.toggle()
    }
    
    @MainActor
    func isShowUpdateAlert() async {
        if await ForceUpdate.shared.shouldUpdate(), shouldShowUpdateAlert {
            isShowUpdateAlert.toggle()
            shouldShowUpdateAlert = false
        } else {
            // nothing to do
        }
    }
    
    var appLaunchCount: Int {
        get {
            appStorageManager.appLaunchCount
        }
    }
    
    var didShowRequestReview: Bool {
        get {
            appStorageManager.didShowRequestReview
        }
        set {
            appStorageManager.didShowRequestReview = newValue
        }
    }
    
    @MainActor
    var lastUpdateDate: Date? {
        get {
            appStorageManager.lastUpdateDate
        }
        set {
            appStorageManager.lastUpdateDate = newValue
        }
    }
    
    // MARK: - workout
    @MainActor
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
    
    @MainActor
    func insert(_ workoutDay: WorkoutDay) {
        guard let workoutRepository else {
            return
        }
        do {
            try workoutRepository.insert(workoutDay)
        } catch {
            
        }
    }
    
    @MainActor
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
    
    @MainActor
    func setTodayWorkout(workoutDays: [WorkoutDay]) {
        let workoutDay = workoutDays.first { workoutDay in
            workoutDay.createdAt.zeroClock == Date().zeroClock
        }
        todayWorkoutDay = workoutDay
    }
    
    @MainActor
    func delete(for workoutDay: WorkoutDay) {
        guard let workoutRepository else { return }
        do {
            try workoutRepository.delete(workoutDay)
        } catch {
            
        }
    }
    
    @MainActor
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
            let newWorkoutDay = WorkoutDay(createdAt: Date().zeroClock, workouts: [newWorkout])
            let setInfo = WorkoutSetInfo(weight: "", rep: "", workout: newWorkout)
            newWorkout.workoutSetInfo.append(setInfo)
            insert(newWorkoutDay)
            todayWorkoutDay = newWorkoutDay
        }
        didAddWorkout.toggle()
    }
    
    @MainActor
    func removeWorkout(_ workoutDay: WorkoutDay, at index: Int) {
        guard let workoutRepository else { return }
        do {
            if workoutDay.workouts.count == 1 {
                let removeWorkout = workoutDay.workouts[index]
                removeSetInfo(workoutDay: workoutDay, at: index)
                workoutDay.workouts.remove(at: index)
                try workoutRepository.delete(removeWorkout)
                delete(for: workoutDay)
            } else {
                let removeWorkout = workoutDay.workouts[index]
                removeSetInfo(workoutDay: workoutDay, at: index)
                workoutDay.workouts.remove(at: index)
                try workoutRepository.delete(removeWorkout)
            }
        } catch {
            
        }
    }
    
    @MainActor
    func addSetInfo(_ workoutDay: WorkoutDay, at workoutIndex: Int) {
        guard let workoutRepository else { return }
        let workoutSetInfo = WorkoutSetInfo(weight: "", rep: "", workout: workoutDay.workouts[workoutIndex])
        workoutDay.workouts[workoutIndex].workoutSetInfo.append(workoutSetInfo)
        do {
            try workoutRepository.save()
        } catch {
            
        }
    }
    
    @MainActor
    func removeSetInfo(workoutDay: WorkoutDay, at workoutIndex: Int) {
        guard let workoutRepository, let removeSetInfo = workoutDay.workouts[workoutIndex].sortedWorkoutSetInfo.last else { return }
        do {
            try workoutRepository.delete(removeSetInfo)
        } catch {
            
        }
    }
    
    // MARK: - exercise
    @MainActor
    func saveDefaultExercise() {
        guard let exerciseRepository else { return }
        do {
            try exerciseRepository.saveDefaultExercise()
        } catch {
            
        }
    }
    
    @MainActor
    func save(_ exercise: Exercise) {
        guard let exerciseRepository else { return }
        do {
            try exerciseRepository.save()
        } catch {
            
        }
    }
    
    @MainActor
    func update(_ exercise: Exercise) throws {
        guard let exerciseRepository else { return }
        do {
            try exerciseRepository.update(exercise)
        } catch {
            onFailureExericesUpdate.toggle()
        }
    }
    
    @MainActor
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
