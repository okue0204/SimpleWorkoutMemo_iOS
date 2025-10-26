//
//  CalendarView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/03.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.safeAreaInsets.top)
                HeaderView(title: "WorkoutCalendar",
                           imageResource: nil,
                           isFromHome: false) { _ in
                    dismiss()
                }
                           .padding(.bottom, 12)
                           .background(.black)
                BannerViewContainer {
                    isHideBanner = true
                }
                .frame(width: displayWidth, height: isHideBanner ? 0 : 50)
                CurrentCalendarSelectTextView(currentPositionDate: $currentPositionDate,
                                              scrollPosition: $scrollPosition,
                                              viewModel: viewModel)
                WeekDayView()
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(viewModel.calendars, id: \.id) { calendarMonth in
                                    MonthView(selectedDate: $selectedDate,
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
    }
}

#Preview {
    @Previewable @State var selectedDate: Date? = Date()
    
    CalendarView(viewModel: CalendarViewModel(),
                 selectedDate: $selectedDate)
}
