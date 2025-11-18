//
//  CalendarView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/03.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @EnvironmentObject var subscription: SubscriptionManager
    @Environment(\.dismiss) var dismiss
    @Query private var workoutDays: [WorkoutDay]
    @State var viewModel: CalendarViewModel
    @Binding var selectedDate: Date?
    
    @State private var currentPositionDate: Date?
    @State private var scrollPosition: String?
    @State private var isShowSheet: Bool = false
    @State private var isHideBanner: Bool = false
    
    private var displayWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.safeAreaInsets.top)
                    BannerViewContainer {
                        isHideBanner = true
                    }
                    .frame(width: displayWidth,
                           height: subscription.isSubscribed ? 0 : isHideBanner ? 0 : 50)
                    CurrentCalendarSelectTextView(currentPositionDate: $currentPositionDate,
                                                  scrollPosition: $scrollPosition,
                                                  viewModel: viewModel)
                    WeekDayView()
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(viewModel.calendars, id: \.id) { calendarMonth in
                                        MonthView(selectedDate: $selectedDate,
                                                  workoutDays: workoutDays,
                                                  viewModel: viewModel,
                                                  calendarMonth: calendarMonth)
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .scrollPosition(id: $scrollPosition)
                            .onChange(of: scrollPosition) { oldValue, newValue in
                                currentPositionDate = viewModel.currentPositionDate(for: newValue)
                            }
                        }
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 12)
                    Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.safeAreaInsets.bottom)
                }
                .background(.black)
                .ignoresSafeArea(.all)
                .onAppear {
                    AnalyticsManager.logEvent(.showCalendar)
                    viewModel.createCalendarMonth()
                }
                .onChange(of: selectedDate, { oldValue, newValue in
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if let newValue,
                       let workoutDay = viewModel.workoutDay(for: newValue, from: workoutDays),
                       !workoutDay.workouts.isEmpty {
                        DispatchQueue.main.async {
                            isShowSheet.toggle()
                        }
                    }
                })
                .sheet(isPresented: $isShowSheet, onDismiss: {
                    selectedDate = nil
                }, content: {
                    if let selectedDate,
                       let workoutDay = viewModel.workoutDay(for: selectedDate, from: workoutDays) {
                        WorkoutHalfModelView(viewModel: WorkoutHalfModelViewModel(),
                                             selectedDate: $selectedDate,
                                             workoutDay: workoutDay)
                            .presentationDetents([.medium, .large])
                    }
                })
            }
            .navigationTitle("ワークアウトカレンダー")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    @Previewable @State var selectedDate: Date? = Date()
    
    CalendarView(viewModel: CalendarViewModel(),
                 selectedDate: $selectedDate)
    .environmentObject(SubscriptionManager.shared)
}
