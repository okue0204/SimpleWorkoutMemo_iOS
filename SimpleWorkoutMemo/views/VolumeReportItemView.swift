//
//  VolumeReportItemView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/27.
//

import SwiftUI
import SwiftData

struct VolumeReportItemView: View {
    @Query private var workoutDays: [WorkoutDay]
    @Query private var exercises: [Exercise]
    @State var viewModel: VolumeReportItemViewModel
    
    let parts: Parts
    let volumeReport: VolumeType
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(volumeReport == .maxVolume ? "種目数" : "最大ボリューム")
                .font(.medium(size: 12))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
            Text(
                volumeReport == .maxVolume ? String(viewModel.exercises.count)  : viewModel.totalVolume
            )
            .font(.bold(size: 22))
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            Text(parts.title)
                .font(.medium(size: 12))
                .foregroundStyle(.white)
        }
        .frame(width: 100, height: 100)
        .padding(.vertical, 12)
        .padding(.horizontal, 6)
        .background(
            LinearGradient(colors: [.orange.opacity(0.4), .red.opacity(0.4)], startPoint: .top, endPoint: .bottom)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            switch volumeReport {
            case .maxVolume:
                viewModel.fetchExercise(for: parts, exercises: exercises)
            case .totalVolume:
                viewModel.fetchTotalVolume(for: parts, workoutDays: workoutDays)
            }
        }
    }
}

#Preview {
    VolumeReportItemView(viewModel: VolumeReportItemViewModel(),
                         parts: .chest,
                         volumeReport: .totalVolume)
}
