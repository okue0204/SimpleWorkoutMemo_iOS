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
    @FocusState.Binding var focusedField: FocusField?
    
    @State private var currentPositionDate: Date?
    @State private var scrollPosition: String?
    @State private var isShowSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Calendar",
                       imageResource: .icWorkoutClose,
                       isFromHome: false) { _ in 
                dismiss()
            }
                       .padding(.vertical, 12)
                       .background(.black)
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
        }
        .background(.black)
        .ignoresSafeArea()
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

#Preview {
    @Previewable @State var selectedDate: Date? = Date()
    @Previewable @FocusState var focusedField: FocusField?
    CalendarView(viewModel: CalendarViewModel(),
                 selectedDate: $selectedDate,
                 focusedField: $focusedField)
}
