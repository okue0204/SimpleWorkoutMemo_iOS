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
    @State var viewModel: HomeViewModel
    @State private var isShowSelectedWorkoutMenu: Bool = false
    @State private var isShowAddWorkoutMenu: Bool = false
    @State private var isShowSetting: Bool = false
    @State private var updateWorkoutDay: WorkoutDay?
    @State private var isInitialized = false
    @FocusState private var focusedField: FocusField?
    
    @Query private var workoutDays: [WorkoutDay]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HeaderView(title: "Today's Workout Memory",
                           imageResource: .icWorkoutSetting) {
                    isShowSetting.toggle()
                }
                ScrollView {
                    HStack {
                        Text(DateFormatter.dateToString(Date()))
                            .font(.regular(size: 18))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    let workoutDays = workoutDays.filter { day in
                        day.createdAt.zeroClock == Date().zeroClock
                    }
                    ForEach(workoutDays, id: \.id) { workoutDay in
                        ForEach(workoutDay.workouts, id: \.id) { workout in
                            WorkoutItemView(focusedField: $focusedField,
                                            workout: workout) {
                                viewModel.addSetInfo(workoutDay, at: workoutDay.workouts.firstIndex(of: workout)!)
                            } onRemoveSetInfo: { _ in
                                viewModel.removeSetInfo(workoutDay: workoutDay, at: workoutDay.workouts.firstIndex(of: workout)!)
                            } onUpdateWorkoutSetInfo: { workoutSetInfo in
                                viewModel.update(workout: workout, with: workoutSetInfo, at: workoutDay.workouts.firstIndex(of: workout)!)
                            } onDeleteWorkout: { workout in
                                let index = workoutDay.workouts.firstIndex(of: workout)!
                                viewModel.removeWorkout(workoutDay, at: index)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    Color.clear.padding(.bottom, 80)
                }
            }
            if isInitialized {
                MenuView(viewModel: viewModel)
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
            if let todayWorkoutDay = workoutDays.first(where: { workoutDay in
                workoutDay.createdAt.zeroClock == Date().zeroClock
            }) {
                viewModel.calculateTotalWeight(workoutDay: todayWorkoutDay)
            }
        })
        .onTapGesture {
            focusedField = nil
        }
        .sheet(isPresented: $isShowSelectedWorkoutMenu) {
            SelectWorkoutMenuView()
        }
    }
}

// MARK: - Extension HomeView
extension HomeView {
    struct MenuView: View {
        @Query private var workoutDays: [WorkoutDay]
        @Query private var exercises: [Exercise]
        @State var viewModel: HomeViewModel
        @State var isShowCalendar: Bool = false
    
        var body: some View {
            HStack(spacing: 20) {
                Spacer()
                Button(action: {
                    isShowCalendar.toggle()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 60, height: 60)
                        Image(.icWorkoutCalendar)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.blue)
                    }
                }
                Menu {
                    ForEach(Parts.allCases.reversed(), id: \.self) { part in
                        let exercises = exercises.filter { $0.parts == part }
                        if !exercises.isEmpty {
                            Menu(part.title) {
                                ForEach(exercises, id: \.id) { exercise in
                                    Button(exercise.exerciseName) {
                                        viewModel.addWorkout(workoutDays, exercise: exercise)
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 60, height: 60)
                        Image(.icWorkoutAdd)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.blue)
                    }
                }
            }
            .padding(.trailing, 26)
            .padding(.bottom, 20)
            .sheet(isPresented: $isShowCalendar) {
                CalendarView(viewModel: CalendarViewModel(), workoutDays: workoutDays)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView(viewModel: HomeViewModel())
        .environmentObject(AppStorageManager.shared)
}
