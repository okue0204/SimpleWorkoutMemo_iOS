//
//  SelectWorkoutListItemView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/09.
//

import SwiftUI

struct WorkoutListItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedExerciseId: ExerciseId?
    @State var viewModel: WorkoutListViewModel
    @State var isShowDeleteExerciseAlert: Bool = false
    let exercise: Exercise
    var onUpdateExercise: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(exercise.exerciseName)
                .font(.regular(size: 16))
                .foregroundStyle(.white)
            Spacer()
            Menu {
                Button(action: {
                    // ハーフモーダル出して編集画面に遷移
                    selectedExerciseId = .init(id: exercise.id)
                }) {
                    Label("編集", systemImage: "edit")
                }
                Button(role: .destructive) {
                    isShowDeleteExerciseAlert.toggle()
                } label: {
                    Label("種目の削除", systemImage: "trash")
                }
            } label: {
                Image(.icWorkoutMore)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal, 20)
        .alert("本当に削除しますか？", isPresented: $isShowDeleteExerciseAlert) {
            Button("キャンセル", role: .cancel) {}
            Button("削除する", role: .destructive) {
                viewModel.delete(exercise)
                onUpdateExercise?()
                AnalyticsManager.logEvent(.removeWorkout)
            }
        } message: {
            Text("登録されているトレーニングも削除されます。")
                .font(.regular(size: 14))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    @Previewable @State var selectedExerciseId: ExerciseId? = .init(id: "")
    @Previewable @State var isShowWorkoutSetting: Bool = false
    WorkoutListItemView(selectedExerciseId: $selectedExerciseId,
                              viewModel: WorkoutListViewModel(),
                              exercise: .init(parts: .chest,
                                              workoutType: .freeWeight,
                                              exerciseName: "ダンベルプレス")) {
        
    }
}
