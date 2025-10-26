//
//  WorkoutAddMenuView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/10.
//

import SwiftUI
import SwiftData

struct WorkoutAddMenuView: View {
    @Query private var workoutDays: [WorkoutDay]
    @Query private var exercises: [Exercise]
    @State var viewModel: HomeViewModel

    var body: some View {
        HStack(spacing: 20) {
            Spacer()
            Menu {
                ForEach(Parts.allCases.reversed(), id: \.id) { part in
                    let exercises = viewModel.filteredExercises.filter { $0.parts == part }
                    if !exercises.isEmpty {
                        Menu(part.title) {
                            Menu("自重") {
                                let machineWeightExercises = exercises.filter {
                                    $0.workoutType == .bodyweight
                                }
                                ForEach(machineWeightExercises, id: \.id) { exercise in
                                    Button(exercise.exerciseName) {
                                        viewModel.addWorkout(workoutDays, exercise: exercise)
                                        viewModel.filter(for: self.exercises)
                                    }
                                }
                            }
                            Menu("マシン") {
                                let machineWeightExercises = exercises.filter {
                                    $0.workoutType == .machine
                                }
                                ForEach(machineWeightExercises, id: \.id) { exercise in
                                    Button(exercise.exerciseName) {
                                        viewModel.addWorkout(workoutDays, exercise: exercise)
                                        viewModel.filter(for: self.exercises)
                                    }
                                }
                            }
                            Menu("フリーウェイト") {
                                let freeWeightExercises = exercises.filter {
                                    $0.workoutType == .freeWeight
                                }
                                ForEach(freeWeightExercises, id: \.id) { exercise in
                                    Button(exercise.exerciseName) {
                                        viewModel.addWorkout(workoutDays, exercise: exercise)
                                        viewModel.filter(for: self.exercises)
                                    }
                                }
                            }
                        }
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 60, height: 60)
                    Image(.icWorkoutAdd)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.blue)
                }
            }
        }
        .padding(.trailing, 26)
        .padding(.bottom, 20)
        .onAppear(perform: {
            AnalyticsManager.logEvent(.addWorkout)
            viewModel.setTodayWorkout(workoutDays: workoutDays)
            viewModel.filter(for: exercises)
        })
    }
}

#Preview {
    @Previewable @State var selectedDate: Date? = Date()
    WorkoutAddMenuView(viewModel: HomeViewModel())
}
