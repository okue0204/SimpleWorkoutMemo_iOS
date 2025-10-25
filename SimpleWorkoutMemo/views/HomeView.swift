//
//  ContentView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/20.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appStorageManager: AppStorageManager
    @StateObject var appOpen = AppOpenAdManager()
    @State var viewModel: HomeViewModel
    @State var headerAction: HeaderAction?
    @State private var isShowSelectedWorkoutMenu: Bool = false
    @State private var isShowAddWorkoutMenu: Bool = false
    @State private var isShowSetting: Bool = false
    @State private var updateWorkoutDay: WorkoutDay?
    @State private var isInitialized = false
    @State private var selectedDate: Date?
    @State private var isSettingTargetDays: Bool = false
    @State private var settingTargetText: String = ""
    @FocusState private var focusedField: FocusField?
    
    @Query private var workoutDays: [WorkoutDay]
    @Query private var exercise: [Exercise]
    
    private var displayWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HeaderView(title: "Today's Workout Memory",
                           imageResource: .icWorkoutMore,
                           isFromHome: true) { type in
                    headerAction = type
                }
                ScrollView {
                    DateHeaderView(selectedDate: $selectedDate)
                    let workoutDays = workoutDays.filter { day in
                        day.createdAt.zeroClock == Date().zeroClock
                    }
                    BannerViewContainer {}
                    .frame(width: displayWidth, height: 50)
                    ForEach(workoutDays, id: \.id) { workoutDay in
                        ForEach(workoutDay.workouts, id: \.id) { workout in
                            let previousWorkout = viewModel.fetchPreviousWorkout(workoutDays: self.workoutDays, todayWorkout: workout)
                            return WorkoutItemView(focusedField: $focusedField,
                                                   workout: workout,
                                                   previousWorkout: previousWorkout) {
                                viewModel.addSetInfo(workoutDay, at: workoutDay.workouts.firstIndex(of: workout)!)
                            } onRemoveSetInfo: { _ in
                                viewModel.removeSetInfo(workoutDay: workoutDay, at: workoutDay.workouts.firstIndex(of: workout)!)
                            } onUpdateWorkoutSetInfo: { workoutSetInfo in
                                viewModel.update(workout: workout, with: workoutSetInfo, at: workoutDay.workouts.firstIndex(of: workout)!)
                            } onDeleteWorkout: { workout in
                                let index = workoutDay.workouts.firstIndex(of: workout)!
                                viewModel.removeWorkout(workoutDay, at: index)
                                viewModel.setTodayWorkout(workoutDays: workoutDays)
                                viewModel.filter(for: exercise)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    Color.clear.padding(.bottom, 80)
                }
            }
            if isInitialized {
                WorkoutAddMenuView(viewModel: viewModel)
                    .padding(.top, 12)
            }
        }
        .onAppear(perform: {
            viewModel.setContext(context: modelContext)
            if appStorageManager.isFirstTimeAppLaunch {
                viewModel.saveDefaultExercise()
                appStorageManager.isFirstTimeAppLaunch = false
            }
            isInitialized = true
            viewModel.incrementLaunchCount()
            viewModel.showSettingTargetDaysAlertIfNeeded()
        })
        .onTapGesture {
            focusedField = nil
        }
        .sheet(item: $headerAction) { item in
            switch item {
            case HeaderAction.app:
                SettingView()
            case HeaderAction.workout:
                WorkoutListView(viewModel: WorkoutListViewModel()) {
                    viewModel.filter(for: exercise)
                }
            }
        }
        .task {
            await appOpen.loadAd()
            await viewModel.isShowUpdateAlert()
        }
        .onChange(of: appOpen.appOpenAdLoaded) { oldValue, newValue in
            if viewModel.appLaunchCount > EnvironmentConstant.showAdOpenLimitCount, appStorageManager.isShowLastTimeAppLaunch {
                appOpen.presentAppOpenAd()
            }
            viewModel.resetLastAppLaunch()
        }
        .alert("ワークアウト設定", isPresented: $viewModel.isShowSettingTargetDays) {
            TextField("日数を指定", text: $settingTargetText)
                .keyboardType(.numberPad)
            Button("OK") {
                viewModel.settingTargetDays = Int(settingTargetText) ?? 0
            }
        } message: {
            Text("週に何日トレーニングを行いますか？")
                .font(.regular(size: 14))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView(viewModel: HomeViewModel(), headerAction: .app)
        .environmentObject(AppStorageManager.shared)
}
