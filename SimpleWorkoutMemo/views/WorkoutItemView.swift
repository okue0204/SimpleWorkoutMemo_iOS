//
//  WorkoutItemView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/20.
//

import SwiftUI

struct WorkoutItemView: View {
    
    @FocusState.Binding var focusedField: FocusField?
    @State private var isShowDeleteWorkoutAlert: Bool = false
    var workout: Workout
    var previousWorkout: Workout?
    
    private static let maxLength: Int = 5
    
    let onAddSetInfo: () -> Void
    let onRemoveSetInfo: (Int) -> Void
    let onUpdateWorkoutSetInfo: (WorkoutSetInfo) -> Void
    let onDeleteWorkout: (Workout) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                HStack(spacing: 0) {
                    if let exercise = workout.exercise {
                        ZStack {
                            Circle().fill(exercise.parts.color.opacity(0.6))
                                .frame(width: 50, height: 50)
                            Text(exercise.parts.title)
                                .font(.medium(size: 16))
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(exercise.exerciseName)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(exercise.parts.color.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .font(.medium(size: 12))
                                    .foregroundStyle(exercise.parts.color)
                                Spacer()
                                WorkoutSetControlView(workout: workout,
                                                      onAddSetInfo: onAddSetInfo,
                                                      onRemoveSetInfo: onRemoveSetInfo)
                                .padding(.trailing, 12)
                            }
                            HStack(spacing: 12) {
                                if previousWorkout != nil {
                                    VStack(alignment: .center, spacing: 12) {
                                        Text("今回")
                                            .font(.regular(size: 12))
                                        Text("前回")
                                            .font(.regular(size: 12))
                                        Text("結果")
                                            .font(.regular(size: 12))
                                    }
                                }
                                VStack(alignment: .center, spacing: 12) {
                                    Text("\(workout.workoutSetInfo.count)セット : \(workout.totalRepString)回")
                                        .font(.regular(size: 12))
                                    if let previousWorkout {
                                        Text("\(previousWorkout.workoutSetInfo.count)セット : \(previousWorkout.totalRepString)回")
                                            .font(.regular(size: 12))
                                        Text(workout.differenceRep(previousWorkout: previousWorkout))
                                            .font(.regular(size: 12))
                                    }
                                }
                                VStack(alignment: .center, spacing: 12) {
                                    Text("総重量 : \(workout.totalWeightString)kg")
                                        .font(.regular(size: 12))
                                    if let previousWorkout {
                                        Text("総重量 : \(previousWorkout.totalWeightString)kg")
                                            .font(.regular(size: 12))
                                        Text("\(workout.differenceWeight(previousWorkout: previousWorkout))kg")
                                            .font(.regular(size: 12))
                                    }
                                }
                            }
                            .padding(.leading, 4)
                        }
                        .padding(.leading, 12)
                    }
                }
                .padding(.vertical, 12)
                .padding(.leading, 12)
            }
            Divider()
            VStack(spacing: 0) {
                ForEach(workout.sortedWorkoutSetInfo, id: \.id) { set in
                    HStack {
                        if let index = workout.sortedWorkoutSetInfo.firstIndex(where: { $0.id == set.id }) {
                            Text("\(index + 1)")
                                .font(.medium(size: 22))
                                .foregroundStyle(.white)
                                .padding(.leading, 12)
                        }
                        Text("set")
                            .font(.regular(size: 16))
                            .foregroundStyle(.white)
                            .offset(y: 2)
                        Spacer()
                        HStack {
                            let focusField = FocusField(id: set.id)
                            TextField("0", text: Binding(
                                get: { set.weight },
                                set: { value in
                                    set.weight = String(value.prefix(Self.maxLength))
                                    onUpdateWorkoutSetInfo(set)
                                }))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .keyboardType(.decimalPad)
                            .font(.regular(size: 16))
                            .frame(minWidth: 50)
                            .contentShape(.rect)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .focused($focusedField, equals: focusField)
                            .onTapGesture {
                                focusedField = focusField
                            }
                            Text("kg")
                                .font(.regular(size: 16))
                                .offset(y: 4)
                            Image(.icWorkoutClose)
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                            TextField("0", text: Binding(
                                get: { set.rep },
                                set: { value in
                                    set.rep = String(value.prefix(Self.maxLength))
                                    onUpdateWorkoutSetInfo(set)
                                }))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .keyboardType(.decimalPad)
                            .font(.regular(size: 16))
                            .frame(minWidth: 50)
                            .contentShape(.rect)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .focused($focusedField, equals: focusField)
                            .onTapGesture {
                                focusedField = focusField
                            }
                            Text("rep")
                                .font(.regular(size: 16))
                                .offset(y: 4)
                        }
                        .padding(.horizontal, 12)
                    }
                    .padding(.vertical, 6)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            Divider()
            HStack {
                Spacer()
                Menu {
                    Button(role: .destructive) {
                        isShowDeleteWorkoutAlert.toggle()
                    } label: {
                        Label("トレーニングの削除", systemImage: "trash")
                    }
                } label: {
                    Image(.icWorkoutMore)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.gray)
                        .padding(.vertical, 4)
                        .padding(.trailing, 20)
                }
            }
            .padding(.top, 6)
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
        .alert("本当に削除しますか？", isPresented: $isShowDeleteWorkoutAlert) {
            Button("キャンセル", role: .cancel) {}
            Button("削除する", role: .destructive) {
                onDeleteWorkout(workout)
                AnalyticsManager.logEvent(.removeWorkout)
            }
        } message: {
            Text("削除すると復元できません。")
                .foregroundStyle(.white)
                .font(.regular(size: 14))
        }
    }
}

extension WorkoutItemView {
    struct WorkoutSetControlView: View {
        
        let workout: Workout
        let onAddSetInfo: () -> Void
        let onRemoveSetInfo: (Int) -> Void
        
        var body: some View {
            HStack(spacing: 12) {
                Button(action: {
                    // set数を減らす
                    guard workout.workoutSetInfo.count != 1 else {
                        return
                    }
                    if let index = workout.workoutSetInfo.firstIndex(where: { info in
                        info.id == workout.workoutSetInfo.last?.id
                    }) {
                        onRemoveSetInfo(index)
                    }
                }) {
                    Image(.icWorkoutMinus)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.blue)
                }
                Rectangle()
                    .frame(width: 1, height: 16)
                    .foregroundStyle(.gray)
                Button(action: {
                    // set数を増やす
                    guard workout.workoutSetInfo.count < 10 else {
                        return
                    }
                    onAddSetInfo()
                }) {
                    Image(.icWorkoutAdd)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}


#Preview {
    @Previewable @FocusState var focusedField: FocusField?
    WorkoutItemView(focusedField: $focusedField,
                    workout: .init(
                        exercise: .init(parts: .chest,
                                        workoutType: .freeWeight,
                                        exerciseName: "ダンベルプレス"),
                        workoutSetInfo: [
                            .init(weight: "25",
                                  rep: "10",
                                  workout: .init(exercise: .init(parts: .triceps,
                                                                 workoutType: .freeWeight,
                                                                 exerciseName: "ダンベルプレス"))),
                            .init(weight: "10",
                                  rep: "12",
                                  workout: .init(exercise: .init(parts: .triceps,
                                                                 workoutType: .freeWeight,
                                                                 exerciseName: "ダンベルプレス")))
                        ])) {
                            
                        } onRemoveSetInfo: { _ in
                            
                        } onUpdateWorkoutSetInfo: { _ in
                            
                        } onDeleteWorkout: { _ in
                            
                        }
}

#Preview("previousWorkout") {
    @Previewable @FocusState var focusedField: FocusField?
    WorkoutItemView(focusedField: $focusedField,
                    workout: .init(
                        exercise: .init(parts: .chest,
                                        workoutType: .freeWeight,
                                        exerciseName: "ダンベルプレス"),
                        workoutSetInfo: [
                            .init(weight: "25",
                                  rep: "10",
                                  workout: .init(exercise: .init(parts: .triceps,
                                                                 workoutType: .freeWeight,
                                                                 exerciseName: "ダンベルプレス"))),
                            .init(weight: "10",
                                  rep: "12",
                                  workout: .init(exercise: .init(parts: .triceps,
                                                                 workoutType: .freeWeight,
                                                                 exerciseName: "ダンベルプレス")))
                        ]),
                    previousWorkout: .init(exercise: .init(parts: .chest,
                                                           workoutType: .freeWeight,
                                                           exerciseName: "ダンベルプレス"),
                                           workoutSetInfo: [
                                            .init(weight: "36",
                                                  rep: "10",
                                                  workout: .init(
                                                    exercise: .init(parts: .chest,
                                                                    workoutType: .freeWeight,
                                                                    exerciseName: "ダンベルプレス")))
                                           ])) {
                            
                        } onRemoveSetInfo: { _ in
                            
                        } onUpdateWorkoutSetInfo: { _ in
                            
                        } onDeleteWorkout: { _ in
                            
                        }
}
