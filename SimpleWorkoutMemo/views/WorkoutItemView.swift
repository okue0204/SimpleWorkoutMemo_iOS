//
//  WorkoutItemView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/20.
//

import SwiftUI

struct WorkoutItemView: View {
    
    @FocusState.Binding var focusedField: FocusField?
    @Bindable var workout: Workout
    
    private static let maxLength: Int = 5
    
    let onAddSetInfo: () -> Void
    let onRemoveSetInfo: (Int) -> Void
    let onUpdateWorkoutSetInfo: (WorkoutSetInfo) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                ZStack {
                    Circle().fill(workout.exercise.parts.color.opacity(0.6))
                        .frame(width: 50, height: 50)
                    Text(workout.exercise.parts.title)
                        .font(.medium(size: 20))
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text(workout.exercise.exerciseName)
                        .padding(.horizontal, 10)
                        .background(workout.exercise.parts.color.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .font(.medium(size: 16))
                        .foregroundStyle(workout.exercise.parts.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                    Text("合計 : \(workout.workoutSetInfo.count)セット")
                        .font(.regular(size: 14))
                        .padding(.leading, 16)
                }
                Spacer()
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
                            .frame(width: 20, height: 20)
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
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
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
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
    }
}


#Preview {
    @Previewable @FocusState var focusedField: FocusField?
    WorkoutItemView(focusedField: $focusedField,
                    workout: .init(exercise: .init(parts: .chest,
                                                   workoutType: .freeWeight,
                                                   exerciseName: "ダンベルプレス"),
                                   workoutSetInfo: [
                                    
                                   ])) {
                                       
                                   } onRemoveSetInfo: { _ in
                                       
                                   } onUpdateWorkoutSetInfo: { _ in
                                       
                                   }
}
