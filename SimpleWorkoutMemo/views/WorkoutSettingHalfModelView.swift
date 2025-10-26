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
    @State var selectedParts: Parts?
    @State var isShowAddExerciseAlert: Bool = false
    let exerciseId: String?
    let isEditWorkout: Bool?
    var onUpdateExercise: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 0) {
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
                    Spacer()
                    Button(action: {
                        if isEditWorkout == nil {
                            if let selectedParts, let selectedWorkoutType, !text.isEmpty {
                                viewModel.addExercise(.init(parts: selectedParts,
                                                            workoutType: selectedWorkoutType,
                                                            exerciseName: _text.wrappedValue))
                                text = ""
                                onUpdateExercise?()
                                dismiss()
                                AnalyticsManager.logEvent(.addWorkout)
                            } else {
                                isShowAddExerciseAlert.toggle()
                            }
                        } else {
                            if let exercise = viewModel.selectedExercise(exercises: exercises, for: exerciseId) {
                                viewModel.updateExercise(exercise,
                                                         name: text,
                                                         workoutType: selectedWorkoutType ?? exercise.workoutType)
                                dismiss()
                                AnalyticsManager.logEvent(.editWorkout)
                            }
                        }
                    }) {
                        Text(isEditWorkout != nil ? "完了" : "追加")
                            .foregroundStyle(.white)
                            .font(.semiBold(size: 14))
                    }
                    .frame(height: 20)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                Text(isEditWorkout != nil ? "トレーニング編集" : "トレーニング追加")
                    .foregroundStyle(.white)
                    .font(.semiBold(size: 16))
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 12)
            if isEditWorkout == nil {
                LazyVGrid(columns: Array(repeating: .init(), count: 7)) {
                    ForEach(Parts.allCases) { parts in
                        Button {
                            selectedParts = parts
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(parts.color)
                                    .opacity(0.6)
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(style: .init(lineWidth: 1.5))
                                            .fill(selectedParts == parts ?
                                                  Color.white : Color.clear)
                                    }
                                Text(parts.title)
                                    .font(.semiBold(size: 14))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 12)
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
            SelectWorkoutTypeView(selectedWorkoutType: $selectedWorkoutType)
                .padding(.top, 20)
        }
        .onAppear {
            viewModel.setContext(context: modelContext)
            if let exercise = viewModel.selectedExercise(exercises: exercises, for: exerciseId) {
                selectedWorkoutType = exercise.workoutType
                text = exercise.exerciseName
            }
        }
        .alert("種目名を入力して下さい。",  isPresented: $isShowAddExerciseAlert) {}
    }
}

#Preview {
    WorkoutSettingHalfModelView(viewModel: WorkoutSettingHalfModelViewModel(),
                                exerciseId: "7F1648AA-1FB9-4D0F-A632-1903FED25811",
                                isEditWorkout: nil)
}
