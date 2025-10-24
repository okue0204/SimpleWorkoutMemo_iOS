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
    var title: String { get }
}

enum ReportType: String, CaseIterable, Identifiable, Reportable {
    case totalDays
    case totalSets
    case totalReps
    case totalLoad
    
    var id: String {
        rawValue
    }
    
    var title: String {
        switch self {
        case .totalDays:
            "総日数"
        case .totalSets:
            "総セット数"
        case .totalReps:
            "総レップ数"
        case .totalLoad:
            "総負荷量"
        }
    }
}

enum ThisWeekReportType: String, CaseIterable, Identifiable, Reportable {
    case thisWeekTotalSets
    case thisWeekTotalReps
    case thisWeekTotalLoad
    
    var id: String {
        rawValue
    }
    
    var title: String {
        switch self {
        case .thisWeekTotalSets:
            "今週の総セット数"
        case .thisWeekTotalReps:
            "今週の総レップ数"
        case .thisWeekTotalLoad:
            "今週の総負荷量"
        }
    }
}
