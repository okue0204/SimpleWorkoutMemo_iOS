//
//  TimePeriod.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/26.
//

import Foundation
import SwiftUI

enum TimePeriod: String, CaseIterable, Identifiable, Hashable, Periodable {
    case today
    case thisWeek
    case thisMonth
    case thisYear
    case all
    
    static var nonAllCases: [TimePeriod] {
        [
            .today, .thisWeek, .thisMonth, .thisYear
        ]
    }
    
    var id: String {
        rawValue
    }
    
    var title: String {
        switch self {
        case .today:
            "日"
        case .thisWeek:
            "週"
        case .thisMonth:
            "月"
        case .thisYear:
            "年"
        case .all:
            "すべて"
        }
    }
    
    var graphTitle: String {
        switch self {
        case .today:
            "今日"
        case .thisWeek:
            "今週"
        case .thisMonth:
            "今月"
        case .thisYear:
            "今年"
        case .all:
            ""
        }
    }
    
    var previousGraphTitle: String {
        switch self {
        case .today:
            ""
        case .thisWeek:
            "先週"
        case .thisMonth:
            "先月"
        case .thisYear:
            "去年"
        case .all:
            ""
        }
    }
}

protocol Periodable: Equatable {
    var title: String { get }
}

extension Periodable {
    var isThisPeriod: Bool {
        return switch self {
        case let week as WeekPeriod:
            week == .thisWeek
        case let month as MonthPeriod:
            month == .thisMonth
        case let year as YearPeriod:
            year == .thisYear
        default:
            false
        }
    }
}

enum TodayPeriod: Periodable {
    case today
    
    var title: String {
        "今日"
    }
}

enum WeekPeriod: Periodable {
    case thisWeek
    case lastWeek
    
    var title: String {
        switch self {
        case .thisWeek:
            "今週"
        case .lastWeek:
            "先週"
        }
    }
}

enum MonthPeriod: Periodable {
    case thisMonth
    case lastMonth
    
    var title: String {
        switch self {
        case .thisMonth:
            "今月"
        case .lastMonth:
            "先月"
        }
    }
}

enum YearPeriod: Periodable {
    case thisYear
    case lastYear
    
    var title: String {
        switch self {
        case .thisYear:
            "今年"
        case .lastYear:
            "去年"
        }
    }
}
