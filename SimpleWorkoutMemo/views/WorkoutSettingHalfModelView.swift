//
//  WorkoutSettingHalfModelView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/08.
//

import SwiftUI
import SwiftData

struct WorkoutSettingHalfModelView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var exercises: [Exercise]
    @FocusState var isFocused: Bool
    @State var viewModel: WorkoutSettingHalfModelViewModel
    @State var text: String = ""
    @State var selectedWorkoutType: WorkoutType?
    let exerciseId: String?
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                HStack(alignment: .center, spacing: 0) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("キャンセル")
                            .foregroundStyle(.white)
                            .font(.semiBold(size: 14))
                    }
                    .frame(height: 20)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.leading, 12)
                    Spacer()
                    Button(action: {
                        if let exercise = viewModel.selectedExercise(exercises: exercises, for: exerciseId) {
                            viewModel.updateExercise(exercise,
                                                     name: text,
                                                     workoutType: selectedWorkoutType ?? exercise.workoutType)
                            dismiss()
                        }
                    }) {
                        Text("完了")
                            .foregroundStyle(.white)
                            .font(.semiBold(size: 14))
                    }
                    .frame(height: 20)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.trailing, 12)
                }
                .padding(.bottom, 20)
                Text("トレーニング編集")
                    .foregroundStyle(.white)
                    .font(.semiBold(size: 16))
                    .padding(.bottom, 20)
            }
            TextField("新しい種目を入力", text: $text)
                .focused($isFocused)
                .frame(height: 50)
                .padding(.leading, 20)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 12)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Spacer()
                            Button(action: {
                                isFocused = false
                            }) {
                                Image(.icWorkoutHideKeyboard)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }
                }
            HStack(spacing: 20) {
                Spacer()
                Button(action: {
                    selectedWorkoutType = .freeWeight
                }) {
                    HStack {
                        Image(selectedWorkoutType == .freeWeight ?
                            .icWorkoutCheckCircle : .icWorkoutCircle)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                        Text("フリーウェイト")
                            .foregroundStyle(.white)
                            .font(.regular(size: 16))
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 2)
                        .fill(selectedWorkoutType == .freeWeight ? Color.yellow : Color.clear)
                }
                Spacer()
                Button(action: {
                    selectedWorkoutType = .machine
                }) {
                    HStack {
                        Image(selectedWorkoutType == .machine ?
                            .icWorkoutCheckCircle : .icWorkoutCircle)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                        Text("マシン")
                            .foregroundStyle(.white)
                            .font(.regular(size: 16))
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 2)
                        .fill(selectedWorkoutType == .machine ? Color.yellow : Color.clear)
                }
                Spacer()
            }
            .padding(.vertical, 20)
        }
        .onAppear {
            viewModel.setContext(context: modelContext)
            if let exercise = viewModel.selectedExercise(exercises: exercises, for: exerciseId) {
                selectedWorkoutType = exercise.workoutType
                text = exercise.exerciseName
            }
        }
    }
}

#Preview {
    WorkoutSettingHalfModelView(viewModel: WorkoutSettingHalfModelViewModel(),
                                exerciseId: "7F1648AA-1FB9-4D0F-A632-1903FED25811")
}
