//
//  MonthView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/16.
//

import SwiftUI
import SwiftData

struct MonthView: View {
    
    @Binding var selectedDate: Date?
    @Query var workoutDays: [WorkoutDay]
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

#Preview {
    @Previewable @State var selectedDate: Date? = Date()
    MonthView(selectedDate: $selectedDate,
              viewModel: CalendarViewModel(),
              calendarMonth: .init(id: UUID().uuidString, date: Date()))
}
