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
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                isShowWorkoutSetting.toggle()
            }) {
                addWorkoutButton()
            }
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(.horizontal, 12)
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                dismiss()
            }) {
                closeButton()
            }
            .padding(.trailing, 20)
        }
        .sheet(isPresented: $isShowWorkoutSetting) {
            WorkoutSettingHalfModelView(viewModel: WorkoutSettingHalfModelViewModel(),
                                        exerciseId: nil,
                                        isEditWorkout: nil) {
                onUpdateExercise?()
            }
            .presentationDetents([.fraction(1/2)])
        }
    }
    
    @ViewBuilder
    private func addWorkoutButton() -> some View {
        if #available(iOS 26.0, *) {
            Text("種目を追加")
                .font(.medium(size: 16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .glassEffect()
        } else {
            Text("種目を追加")
                .font(.medium(size: 16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: 50)
        }
    }
    
    @ViewBuilder
    private func closeButton() -> some View {
        if #available(iOS 26.0, *) {
            Image(.icWorkoutClose)
                .resizable()
                .frame(width: 16, height: 16)
                .padding()
                .glassEffect()
        } else {
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(.icWorkoutClose)
                    .resizable()
                    .frame(width: 16, height: 16)
            }
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
