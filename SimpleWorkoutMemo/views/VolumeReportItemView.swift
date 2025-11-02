//
//  VolumeReportItemView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/27.
//

import SwiftUI
import SwiftData

struct VolumeReportItemView: View {
    @EnvironmentObject var subscription: SubscriptionManager
    @Query private var workoutDays: [WorkoutDay]
    @Query private var exercises: [Exercise]
    @State var viewModel: VolumeReportItemViewModel
    @State private var isShowPremium = false
    
    let parts: Parts
    let volumeReport: VolumeType
    
    var body: some View {
        ZStack {
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
            .blur(radius: blurRadius())
            .frame(width: 100, height: 100)
            .padding(.vertical, 12)
            .padding(.horizontal, 6)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onAppear {
                switch volumeReport {
                case .maxVolume:
                    viewModel.fetchExercise(for: parts, exercises: exercises)
                case .totalVolume:
                    viewModel.fetchTotalVolume(for: parts, workoutDays: workoutDays)
                }
            }
            if !subscription.isSubscribed {
                VStack(spacing: 12) {
                    Text("プレムアムプラン\nで表示")
                        .font(.semiBold(size: 10))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    Button {
                        isShowPremium.toggle()
                    } label: {
                        Text("プレミアムプラン\nを確認する")
                            .padding(.horizontal, 6)
                            .padding(.vertical, 6)
                            .background(.blue.opacity(0.3))
                            .font(.bold(size: 10))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .sheet(isPresented: $isShowPremium) {
            SubscriptionView()
                .environmentObject(SubscriptionManager.shared)
        }
    }
    
    private func blurRadius() -> CGFloat {
        if !subscription.isSubscribed {
            8
        } else {
            0
        }
    }
}

#Preview {
    VolumeReportItemView(viewModel: VolumeReportItemViewModel(),
                         parts: .chest,
                         volumeReport: .totalVolume)
    .environmentObject(SubscriptionManager.shared)
}
