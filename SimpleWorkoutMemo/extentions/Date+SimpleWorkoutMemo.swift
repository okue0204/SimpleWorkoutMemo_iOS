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
        if weekNumber == WeekDay.sunday.rawValue {
            return Calendar.appCalendar.date(byAdding: .day, value: 0, to: self) ?? Date()
        } else {
            let value = weekNumber - 1
            return Calendar.appCalendar.date(byAdding: .day, value: -value, to: self) ?? Date()
        }
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
    
    // その月のdateの配列
    var monthArray: Array<Date> {
        (1...daysInMonth(self)).compactMap { day in
            Calendar.appCalendar.date(from: .init(calendar: Calendar.appCalendar, year: year, month: month, day: day))
        }
    }
    
    // その年の最初の日付
    var firstDayOfYear: Date {
        Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year, month: 1))!
    }
    // その年の最後の日付
    var lastDayOfYear: Date {
        Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year, month: 12 + 1, day: 0))!
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
        (0...6).compactMap { num in
            Calendar.appCalendar.date(byAdding: .day, value: num, to: firstDayOfWeek)
        }
    }
    
    // 先週のDateの配列
    var lastWeekDates: [Date] {
        let lastWeekFirstDayOfWeek = Calendar.appCalendar.date(byAdding: .day, value: -7, to: firstDayOfWeek)!
        return (0...6).compactMap { num in
            Calendar.appCalendar.date(byAdding: .day, value: num, to: lastWeekFirstDayOfWeek)
        }
    }
    
    // 今月のDateの配列
    var currentMonthDates: [Date] {
        (0...lastDateOfMonth.day - 1).compactMap { num in
            Calendar.appCalendar.date(byAdding: .day, value: num, to: firstDayOfMonth)
        }
    }
    
    // 先月のDateの配列
    var lastMonthDates: [Date] {
        let lastMonth = firstDayOfMonth.addMonth(-1)
        let lastMonthCount = Date().daysInMonth(lastMonth)
        return (0...lastMonthCount - 1).compactMap { num in
            Calendar.appCalendar.date(byAdding: .day, value: num, to: lastMonth)
        }
    }
    
    // 今年の1月~12月までのDateの配列
    var currentYearDates: [Date] {
        let result = (1...12).flatMap { month in
            guard let startOfMonth = Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year, month: month, day: 1)),
                  let range = Calendar.appCalendar.range(of: .day, in: .month, for: startOfMonth) else {
                return []
            }
            return range.compactMap { day in
                Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year, month: month, day: day))
            }
        }
        return result.compactMap {
            $0 as? Date
        }
    }
    
    // 去年の1月~12月までのDateの配列
    var lastYearDates: [Date] {
        let result = (1...12).flatMap { month in
            guard let startOfMonth = Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year - 1, month: month, day: 1)),
                  let range = Calendar.appCalendar.range(of: .day, in: .month, for: startOfMonth) else {
                return []
            }
            return range.compactMap { day in
                Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year - 1, month: month, day: day))
            }
        }
        return result.compactMap {
            $0 as? Date
        }
    }
    
    // 推移グラフ用
    var midDate: Date {
        Calendar.appCalendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    // 指定した数だけ日数を進めたり引いたり
    func addAndSubtractDay(_ value: Int) -> Date {
        Calendar.appCalendar.date(byAdding: .day, value: value, to: self) ?? Date()
    }
    
    func addMonth(_ value: Int) -> Date {
        Calendar.appCalendar.date(byAdding: .month, value: value, to: self) ?? Date()
    }
    
    func addYear(_ value: Int) -> Date {
        Calendar.appCalendar.date(byAdding: .year, value: value, to: self) ?? Date()
    }
    
    func firstDayOfPeriod(for timePeriod: TimePeriod) -> Date {
        switch timePeriod {
        case .today, .thisWeek:
            firstDayOfWeek
        case .thisMonth:
            firstDayOfMonth
        case .thisYear:
            Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year))!
        case .all:
            fatalError()
        }
    }
    
    func lastDayOfPeriod(for timePeriod: TimePeriod) -> Date {
        switch timePeriod {
        case .today, .thisWeek:
            lastDayOfWeek
        case .thisMonth:
            lastDateOfMonth
        case .thisYear:
            Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year - 1))!
        case .all:
            fatalError()
        }
    }
    
    func previousPeriodArray(for timePeriod: TimePeriod) -> [Date] {
        switch timePeriod {
        case .today, .all:
            fatalError()
        case .thisWeek:
            lastWeekDates
        case .thisMonth:
            lastMonthDates
        case .thisYear:
            [
                Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year - 1))!
            ]
        }
    }
    
    static func yearRange(for value: Int) -> ClosedRange<Date> {
        let startDate = Date().addYear(value).firstDayOfYear
        let endDate = Date().addYear(value).lastDayOfYear
        return (startDate ... endDate)
    }
    
    static func createDate(year: Int) -> Date {
        if year == Date().year {
            Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year, month: Date().month, day: Date().day))!
        } else {
            Calendar.appCalendar.date(from: .init(calendar: .appCalendar, year: year, month: 1, day: 1))!
        }
    }
    
    // その月の日数を返す
    private func daysInMonth(_ date: Date = Date()) -> Int {
        Calendar.appCalendar.range(of: .day, in: .month, for: date)!.count
    }
}
