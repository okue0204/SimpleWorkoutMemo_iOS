//
//  WorkoutHalfModelView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/05.
//

import SwiftUI

struct WorkoutHalfModelView: View {
    @Environment(\.modelContext) private var modelContext
    @State var viewModel: WorkoutHalfModelViewModel
    @Binding var selectedDate: Date?
    @FocusState private var focusedField: FocusField?
    
    let workoutDay: WorkoutDay
    
    var body: some View {
        VStack(spacing: 0) {
            DateHeaderView(selectedDate: $selectedDate)
            ScrollView {
                ForEach(workoutDay.workouts, id: \.id) { workout in
                    WorkoutItemView(focusedField: $focusedField,
                                    workout: workout) {
                        viewModel.addSetInfo(workoutDay, at: workoutDay.workouts.firstIndex(of: workout)!)
                    } onRemoveSetInfo: { _ in
                        viewModel.removeSetInfo(workoutDay: workoutDay, at: workoutDay.workouts.firstIndex(of: workout)!)
                    } onUpdateWorkoutSetInfo: { workoutSetInfo in
                        viewModel.update(workout: workout, with: workoutSetInfo, at: workoutDay.workouts.firstIndex(of: workout)!)
                    } onDeleteWorkout: { workout in
                        let index = workoutDay.workouts.firstIndex(of: workout)!
                        viewModel.removeWorkout(workoutDay, at: index)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .background(.black)
        .onAppear(perform: {
            viewModel.setContext(context: modelContext)
        })
        .onTapGesture {
            focusedField = nil
        }
    }
}

#Preview {
    @Previewable @State var selecteedDate: Date? = Date()
    
    WorkoutHalfModelView(
        viewModel: WorkoutHalfModelViewModel(),
        selectedDate: $selecteedDate,
        workoutDay: .init(
            createdAt: Date(),
            workouts: [
                .init(
                    exercise: .init(
                        parts: .chest,
                        workoutType: .freeWeight,
                        exerciseName: "ダンベルプレス"),
                    workoutSetInfo: [
                        .init(weight: "36",
                              rep: "12",
                              workout: .init(exercise: .init(parts: .chest,
                                                             workoutType: .freeWeight,
                                                             exerciseName: "ダンベルプレス")))
                    ]
                )
            ]
        )
    )
}
