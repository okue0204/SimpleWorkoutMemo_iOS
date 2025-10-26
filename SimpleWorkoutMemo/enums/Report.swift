//
//  ReportType.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/24.
//

import Foundation
import SwiftUI

protocol Reportable {
    var id: String { get }
    func title(for period: TimePeriod) -> String
}

enum AllReportType: String, CaseIterable, Identifiable, Reportable {
    case allTotalDays
    case allTotalSets
    case allTotalReps
    case allTotalLoad
    
    var id: String {
        rawValue
    }
    
    func title(for period: TimePeriod) -> String {
        if case .all  = period {
            switch self {
            case .allTotalDays:
                "総日数"
            case .allTotalSets:
                "総セット数"
            case .allTotalReps:
                "総レップ数"
            case .allTotalLoad:
                "総負荷量"
            }
        } else {
            ""
        }
    }
}

enum ReportType: String, CaseIterable, Identifiable, Reportable {
    case totalSets
    case totalReps
    case totalLoad
    
    var timePeriod: TimePeriod {
        .today
    }
    
    var id: String {
        rawValue
    }
    
    func title(for period: TimePeriod) -> String {
        switch period {
        case .today:
            switch self {
            case .totalSets:
                "今日の総セット数"
            case .totalReps:
                "今日の総レップ数"
            case .totalLoad:
                "今日の総負荷量"
            }
        case .thisWeek:
            switch self {
            case .totalSets:
                "今週の総セット数"
            case .totalReps:
                "今週の総レップ数"
            case .totalLoad:
                "今週の総負荷量"
            }
        case .thisMonth:
            switch self {
            case .totalSets:
                "今月の総セット数"
            case .totalReps:
                "今月の総レップ数"
            case .totalLoad:
                "今月の総負荷量"
            }
        case .thisYear:
            switch self {
            case .totalSets:
                "今年の総セット数"
            case .totalReps:
                "今年の総レップ数"
            case .totalLoad:
                "今年の総負荷量"
            }
        case .all:
            ""
        }
    }
}
