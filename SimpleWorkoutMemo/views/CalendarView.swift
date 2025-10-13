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

extension CalendarView {
    struct CurrentCalendarSelectTextView : View {
        
        @Binding var currentPositionDate: Date?
        @Binding var scrollPosition: String?
        
        var viewModel: CalendarViewModel
        
        var body: some View {
            HStack {
                Text(DateFormatter.dateToString(currentPositionDate ?? Date(), format: .yearMonth))
                    .foregroundStyle(.white)
                    .font(.bold(size: 24))
                Spacer()
                HStack(spacing: 30) {
                    Button(action: {
                        // 先月
                        let date = if let currentPositionDate {
                            currentPositionDate.addMonth(-1).onlyYearAndMonth
                        } else {
                            Date().onlyYearAndMonth
                        }
                        let calendarMonth = viewModel.lastMonthCalendarMonth(for: date)
                        currentPositionDate = calendarMonth.date.zeroClock
                        withAnimation {
                            scrollPosition = calendarMonth.id
                        }
                    }) {
                        Image(.icWorkoutLeftArrow)
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    Button(action: {
                        // 来月
                        let date = if let currentPositionDate {
                            currentPositionDate.onlyYearAndMonth
                        } else {
                            Date().onlyYearAndMonth
                        }
                        let calendarMonth = viewModel.nextMonthCalendarMonth(for: date)
                        currentPositionDate = calendarMonth.date.zeroClock
                        withAnimation {
                            scrollPosition = calendarMonth.id
                        }
                    }) {
                        Image(.icWorkoutRightArrow)
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                }
                .padding(.trailing, 30)
            }
            .padding(.leading, 20)
            .padding(.bottom, 4)
        }
    }
}

extension CalendarView {
    struct WeekDayView: View {
        var body: some View {
            HStack {
                ForEach(WeekDay.allCases) { weekDay in
                    switch weekDay {
                    case .saturday, .sunday:
                        Text(weekDay.title)
                            .foregroundStyle(.gray)
                            .font(.semiBold(size: 14))
                            .frame(maxWidth: .infinity)
                    default:
                        Text(weekDay.title)
                            .foregroundStyle(.white)
                            .font(.semiBold(size: 14))
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 6)
        }
    }
}

extension CalendarView {
    struct MonthView: View {
        
        @Binding var selectedDate: Date?
        @Query private var workoutDays: [WorkoutDay]
        let viewModel: CalendarViewModel
        let calendarMonth: CalendarMonth
        
        var body: some View {
            LazyVGrid(columns: Array(repeating: .init(spacing: 4), count: 7), spacing: 1) {
                ForEach(calendarMonth.date.displayLastMonthArray, id: \.self) { date in
                    if let workoutDay = viewModel.workoutDay(for: date, from: workoutDays) {
                        CalendarItemView(selectedDate: $selectedDate,
                                         date: date,
                                         workoutDay: workoutDay,
                                         isCurrentMonth: false)
                        .opacity(0.5)
                    } else {
                        CalendarItemView(selectedDate: $selectedDate,
                                         date: date,
                                         workoutDay: nil,
                                         isCurrentMonth: false)
                        .opacity(0.5)
                    }
                }
                ForEach(calendarMonth.date.monthArray, id: \.self) { date in
                    if let workoutDay = viewModel.workoutDay(for: date, from: workoutDays) {
                        CalendarItemView(selectedDate: $selectedDate,
                                         date: date,
                                         workoutDay: workoutDay,
                                         isCurrentMonth: true)
                    } else {
                        CalendarItemView(selectedDate: $selectedDate,
                                         date: date,
                                         workoutDay: nil,
                                         isCurrentMonth: true)
                    }
                }
                ForEach(calendarMonth.date.displayNextMonthArray, id: \.self) { date in
                    if let workoutDay = viewModel.workoutDay(for: date, from: workoutDays) {
                        CalendarItemView(selectedDate: $selectedDate,
                                         date: date,
                                         workoutDay: workoutDay,
                                         isCurrentMonth: false)
                        .opacity(0.5)
                    } else {
                        CalendarItemView(selectedDate: $selectedDate,
                                         date: date,
                                         workoutDay: nil,
                                         isCurrentMonth: false)
                        .opacity(0.5)
                    }
                }
            }
            .padding(.top, 12)
            .padding(.horizontal, 4)
            .containerRelativeFrame(.horizontal)
        }
    }
}

extension CalendarView {
    struct CalendarItemView: View {
        @Binding var selectedDate: Date?
        
        private static let maxWorkoutCount: Int = 4
        
        let date: Date
        let workoutDay: WorkoutDay?
        let isCurrentMonth: Bool
        
        var textWidth: CGFloat {
            (UIScreen.main.bounds.width) / 7
        }
        
        var body: some View {
            Button(action: {
                selectedDate = date
            }) {
                VStack(alignment: .center, spacing: 2) {
                    Text("\(date.day)")
                        .font(.regular(size: 16))
                        .frame(width: textWidth)
                        .foregroundStyle(.white)
                    LazyVGrid(
                        columns: Array(repeating: .init(spacing: 0), count: 2),
                        spacing: 4
                    ) {
                        if let workoutDay {
                            ForEach(workoutDay.workouts.prefix(4), id: \.id) { workout in
                                if let exercise = workout.exercise {
                                    ZStack {
                                        Circle()
                                            .fill(exercise.parts.color.opacity(0.5))
                                            .frame(width: 24, height: 24)
                                        Text(exercise.parts.title)
                                            .foregroundStyle(.white)
                                            .font(.semiBold(size: 10))
                                    }
                                }
                            }
                        } else {
                            EmptyView()
                        }
                    }
                    if let workoutDay,
                       workoutDay.createdAt.zeroClock == date.zeroClock,
                       workoutDay.workouts.count > Self.maxWorkoutCount {
                        Text("+ \(workoutDay.workouts.count - Self.maxWorkoutCount)")
                            .foregroundStyle(.gray)
                            .font(.regular(size: 12))
                    }
                    Spacer()
                }
            }
            .frame(height: 100)
            .padding(.bottom, 2)
            .background(date.zeroClock == selectedDate?.zeroClock ?
                        Color.cyan.opacity(0.2) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
}

#Preview {
    @Previewable @State var selectedDate: Date? = Date()
    @Previewable @FocusState var focusedField: FocusField?
    CalendarView(viewModel: CalendarViewModel(),
                 selectedDate: $selectedDate,
                 focusedField: $focusedField)
}

#Preview("itemView", body: {
    @Previewable @State var selectedDate: Date? = Date()
    CalendarView.CalendarItemView(selectedDate: $selectedDate,
                                  date: Date(),
                                  workoutDay: .init(
                                    createdAt: Date(),
                                    workouts: [
                                        .init(exercise: .init(parts: .chest,
                                                              workoutType: .freeWeight,
                                                              exerciseName: "ダンベルプレス")),
                                        .init(exercise: .init(parts: .chest,
                                                              workoutType: .freeWeight,
                                                              exerciseName: "ダンベルフライ")),
                                        .init(exercise: .init(parts: .chest,
                                                              workoutType: .machine,
                                                              exerciseName: "ペックフライ"))
                                    ]), isCurrentMonth: true)
})
