//
//  ContinuousRecordView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/24.
//

import SwiftUI
import SwiftData

struct ContinuousRecordView: View {
    @EnvironmentObject var appStorageManager: AppStorageManager
    @Query var workoutDays: [WorkoutDay]
    @State var isShowChangeTargetDay = false
    
    let viewModel: ReportViewModel
    
    var body: some View {
        Button {
            isShowChangeTargetDay.toggle()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            VStack(spacing: 12) {
                HStack {
                    Text("今週の目標達成日数")
                        .foregroundStyle(.white)
                        .font(.regular(size: 16))
                    Spacer()
                    Image(.icWorkoutRightArrow)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
                VStack(alignment: .center, spacing: 0) {
                    Text("現在の記録")
                        .foregroundStyle(.white)
                        .font(.regular(size: 16))
                    Text(String(viewModel.thisWeekWorkoutCount(workoutDays: workoutDays)))
                        .foregroundStyle(.white)
                        .font(.bold(size: 80))
                    Text("日間")
                        .foregroundStyle(.white)
                        .font(.medium(size: 20))
                    if appStorageManager.settingTargetDays == viewModel.thisWeekWorkoutCount(workoutDays: workoutDays) ||
                        appStorageManager.settingTargetDays < viewModel.thisWeekWorkoutCount(workoutDays: workoutDays) {
                        Text("目標達成しました！🔥\nおめでとうございます！😊\n来週も頑張りましょう！")
                            .foregroundStyle(.white)
                            .font(.regular(size: 16))
                            .padding(.top, 20)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("残り\(appStorageManager.settingTargetDays - viewModel.thisWeekWorkoutCount(workoutDays: workoutDays))日トレーニングすれば\n目標達成です！🔥")
                            .foregroundStyle(.white)
                            .font(.regular(size: 16))
                            .padding(.top, 20)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [.blue.opacity(0.4), .cyan.opacity(0.4)], startPoint: .top, endPoint: .bottom)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $isShowChangeTargetDay) {
            TextFieldHalfModelView(viewModel: viewModel)
                .presentationDetents([.fraction(1/4)])
        }
    }
}

#Preview {
    ContinuousRecordView(viewModel: ReportViewModel())
        .environmentObject(AppStorageManager.shared)
}
