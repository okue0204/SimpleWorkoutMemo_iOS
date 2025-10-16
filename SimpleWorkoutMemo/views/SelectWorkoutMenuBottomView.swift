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
    @State var isShowWorkoutSetting: Bool = false
    let viewModel: WorkoutListViewModel
    var onUpdateExercise: (() -> Void)?
    
    var body: some View {
        HStack {
            Button(action: {
                isShowWorkoutSetting.toggle()
            }) {
                Text("種目を追加")
                    .font(.medium(size: 16))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(.horizontal, 12)
            Button(action: {
                dismiss()
            }) {
                ZStack {
                    Circle()
                        .fill(.blue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(.icWorkoutClose)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
            .padding(.trailing, 20)
        }
        .sheet(isPresented: $isShowWorkoutSetting) {
            WorkoutSettingHalfModelView(viewModel: WorkoutSettingHalfModelViewModel(),
                                        exerciseId: nil,
                                        isEditWorkout: nil) {
                onUpdateExercise?()
            }
            .presentationDetents([.fraction(1/3)])
        }
    }
}

#Preview {
    @Previewable @FocusState var isFocused: Bool
    @Previewable @State var isShowWorkoutSetting: Bool = false
    SelectWorkoutMenuBottomView(isFocused: $isFocused,
                                isShowWorkoutSetting: isShowWorkoutSetting,
                                viewModel: WorkoutListViewModel())
}
