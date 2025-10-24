//
//  CalendarViewModel.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/04.
//

import Foundation
import SwiftUI
import Observation

@Observable
class CalendarViewModel {
    
    // 現在から未来100年のdateの配列
    var calendars: [CalendarMonth] = []
    
    func createCalendarMonth() {
        calendars = (0...100).map { int in
            CalendarMonth(
                id: UUID().uuidString,
                date: Date().addMonth(int)
            )
        }
    }
    
    func workoutDay(for date: Date, from workoutDays: [WorkoutDay]) -> WorkoutDay? {
        if let workoutDay = workoutDays.first(where: { workoutDay in
            workoutDay.createdAt.zeroClock == date.zeroClock
        }) {
            return workoutDay
        } else {
            return nil
        }
    }
    
    func todayCalendarMonth() -> CalendarMonth {
        let calendarMonth = calendars.first { calendarMonth in
            calendarMonth.date.onlyYearAndMonth == Date().onlyYearAndMonth
        }!
        return calendarMonth
    }
    
    func lastMonthCalendarMonth(for date: Date) -> CalendarMonth? {
        let calendarMonth = calendars.first(where: { calendarMonth in
            calendarMonth.date.onlyYearAndMonth == date
        })
        return calendarMonth
    }
    
    func nextMonthCalendarMonth(for date: Date) -> CalendarMonth {
        let calendarMonth = calendars.first(where: { calendarMonth in
            calendarMonth.date.onlyYearAndMonth == date.addMonth(1).onlyYearAndMonth
        })
        return calendarMonth!
    }
    
    func currentPositionDate(for id: String?) -> Date? {
        calendars.first { calendarMonth in
            calendarMonth.id == id
        }?.date
    }
}
