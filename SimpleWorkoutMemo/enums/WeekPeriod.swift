//
//  WeekPeriod.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/25.
//

import Foundation

enum WeekPeriod {
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
