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
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var appStorageManager: AppStorageManager
    @StateObject var appOpen = AppOpenAdManager()
    @State var viewModel: HomeViewModel
    @State var headerAction: HeaderAction?
    @State private var isInitialized = false
    @State private var selectedDate: Date?
    @State private var isHideBanner: Bool = false
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
                        day.createdAt.zeroClock == Date().addAndSubtractDay(14).zeroClock
                    }
                    BannerViewContainer {
                        isHideBanner = true
                    }
                    .frame(width: displayWidth, height: isHideBanner ? 0 : 50)
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
            await viewModel.isShowUpdateAlert()
            await appOpen.loadAd()
        }
        .onChange(of: appOpen.appOpenAdLoaded) { oldValue, newValue in
            Task {
                if viewModel.appLaunchCount > EnvironmentConstant.showAdOpenLimitCount, appStorageManager.isShowLastTimeAppLaunch,
                   await !ForceUpdate.shared.shouldUpdate()
                {
                    appOpen.presentAppOpenAd()
                }
                viewModel.resetLastAppLaunch()
            }
        }
        .onChange(of: viewModel.didAddWorkout, { oldValue, newValue in
            if workoutDays.count >= 10, newValue, !viewModel.didShowRequestReview {
                requestReview()
                AnalyticsManager.logEvent(.showReview)
                viewModel.didShowRequestReview = true
            }
        })
        .alert("最新バージョンがあります。", isPresented: $viewModel.isShowUpdateAlert, actions: {
            Button("OK") {
                UIApplication.shared.open(EnvironmentConstant.appStoreURL)
            }
            Button("キャンセル") {}
        }, message: {
            Text("アップデートして、快適にトレーニングライフを送りましょう😊")
        })
    }
}

// MARK: - Preview
#Preview {
    HomeView(viewModel: HomeViewModel(), headerAction: .app)
        .environmentObject(AppStorageManager.shared)
}
