//
//  SelectWorkoutMenuBottomView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/09.
//

import SwiftUI

struct SelectWorkoutMenuBottomView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState.Binding var isFocused: Bool
    @Binding var text: String
    @Binding var selectedParts: Parts?
    @Binding var selectedWorkoutType: WorkoutType
    @State var isShowAddExerciseAlert: Bool = false
    let viewModel: WorkoutListViewModel
    var onUpdateExercise: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            TextField("新しい種目を入力", text: $text)
                .focused($isFocused)
                .frame(height: 50)
                .padding(.leading, 20)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.horizontal, 12)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        ToolbarKeyboardHiddenView(isFocused: $isFocused) {
                            if let selectedParts, !text.isEmpty {
                                viewModel.addExercise(.init(parts: selectedParts,
                                                            workoutType: .freeWeight,
                                                            exerciseName: _text.wrappedValue))
                                text = ""
                                onUpdateExercise?()
                            } else {
                                isShowAddExerciseAlert.toggle()
                            }
                        }
                    }
                }
            Button(action: {
                dismiss()
            }) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 50, height: 50)
                    Image(.icWorkoutClose)
                        .resizable()
                        .frame(width: 14, height: 14)
                }
            }
            .padding(.trailing, 20)
        }
        .padding(.bottom, 6)
        .alert("種目名を入力して下さい。",  isPresented: $isShowAddExerciseAlert) {}
    }
}

#Preview {
    @Previewable @FocusState var isFocused: Bool
    @Previewable @State var text: String = ""
    @Previewable @State var selectedParts: Parts?
    @Previewable @State var selectedWorkoutType: WorkoutType = .freeWeight
    @Previewable @State var isShowAddExerciseAlert: Bool = false
    SelectWorkoutMenuBottomView(isFocused: $isFocused,
                                text: $text,
                                selectedParts: $selectedParts,
                                selectedWorkoutType: $selectedWorkoutType,
                                isShowAddExerciseAlert: isShowAddExerciseAlert,
                                viewModel: WorkoutListViewModel()) {
        
    }
}
