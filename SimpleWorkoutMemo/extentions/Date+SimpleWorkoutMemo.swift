//
//  Date+SimpleWorkoutMemo.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/27.
//

import Foundation
import SwiftUI

extension Date {
    
    private static let maxCalendarCount = 42
    
    // yyyy年MM月dd日のみに変換したDate
    var zeroClock: Date {
        let dateComponent = DateComponents(calendar: .appCalendar, year: year, month: month, day: day)
        return dateComponent.date ?? Date()
    }
    
    // yyyy年MM月のみに変換したDate
    var onlyYearAndMonth: Date {
        let dateComponent = DateComponents(calendar: .appCalendar, year: year, month: month)
        return dateComponent.date ?? Date()
    }
    
    var year: Int {
        Calendar.appCalendar.component(.year, from: self)
    }
    
    var month: Int {
        Calendar.appCalendar.component(.month, from: self)
    }
    
    var day: Int {
        Calendar.appCalendar.component(.day, from: self)
    }
    
    // 月の最初の曜日
    var firstWeekDayOfMonth: Int {
        Calendar.appCalendar.component(.weekday, from: firstDayOfMonth)
    }
    
    // 月の最終日の曜日
    var lastWeekDayOfMonth: Int {
        Calendar.appCalendar.component(.weekday, from: lastDateOfMonth)
    }
    
    // 週の初日
    var firstDayOfWeek: Date {
        let weekNumber = Calendar.appCalendar.component(.weekday, from: self)
        return Calendar.appCalendar.date(byAdding: .day, value: -weekNumber, to: self) ?? Date()
    }
    
    //　週の最終日
    var lastDayOfWeek: Date {
        let weekNumber = Calendar.appCalendar.component(.weekday, from: self)
        return Calendar.appCalendar.date(byAdding: .day, value: 7 - weekNumber, to: self) ?? Date()
    }
    
    // その月最初の日付
    var firstDayOfMonth: Date {
        Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year, month: month))!
    }
    
    // その月の最後のDate
    var lastDateOfMonth: Date {
        Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year, month: month + 1, day: 0))!
    }
    
    // 月のdateの配列
    var monthArray: Array<Date> {
        (1...daysInMonth(self)).compactMap { day in
            Calendar.appCalendar.date(from: .init(calendar: Calendar.appCalendar, year: year, month: month, day: day))
        }
    }
    
    // 当月で幾つかの先月の最終日を表示する配列
    var displayLastMonthArray: Array<Date> {
        let maxWeedDayCount = 7
        guard firstWeekDayOfMonth != WeekDay.sunday.rawValue else {
            return []
        }
        let displayLastDatesCount = if firstWeekDayOfMonth == WeekDay.saturday.rawValue {
            maxWeedDayCount - 2
        } else {
            maxWeedDayCount - (maxWeedDayCount - firstWeekDayOfMonth) - 2
        }
        return (0...displayLastDatesCount).map { count in
            Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year, month: month, day: -count))!
        }.reversed()
    }
    
    // 当月で幾つかの来月の初日を表示する配列
    // 7 * 6 カレンダーのMaxの数
    var displayNextMonthArray: Array<Date> {
        let displayLastDatesCount = Self.maxCalendarCount - (monthArray.count + displayLastMonthArray.count)
        return (1...displayLastDatesCount).map { count in
            Calendar.appCalendar.date(byAdding: .day, value: count, to: lastDateOfMonth)!
        }
    }
    
    // 今週のDateの配列
    var currentWeekDates: [Date] {
        (1...7).compactMap { num in
            Calendar.appCalendar.date(byAdding: .day, value: num, to: firstDayOfWeek)
        }
    }
    
    // 先週のDateの配列
    var lastWeekDates: [Date] {
        let lastWeekFirstDayOfWeek = Calendar.appCalendar.date(byAdding: .day, value: -7, to: firstDayOfWeek)!
        return (1...7).compactMap { num in
            Calendar.appCalendar.date(byAdding: .day, value: num, to: lastWeekFirstDayOfWeek)
        }
    }
    
    // 指定した数だけ日数を進めたり引いたり
    func addAndSubtractDay(_ value: Int) -> Date {
        Calendar.appCalendar.date(byAdding: .day, value: value, to: self) ?? Date()
    }
    
    func addMonth(_ value: Int) -> Date {
        Calendar.appCalendar.date(byAdding: .month, value: value, to: self) ?? Date()
    }
    
    // その月の日数を返す
    private func daysInMonth(_ date: Date = Date()) -> Int {
        Calendar.appCalendar.range(of: .day, in: .month, for: date)!.count
    }
}
