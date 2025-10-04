//
//  WeekDay.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/04.
//

import Foundation
import SwiftUI

enum WeekDay: Int, CaseIterable, Identifiable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var title: String {
        switch self {
        case .sunday:
            "日"
        case .monday:
            "月"
        case .tuesday:
            "火"
        case .wednesday:
            "水"
        case .thursday:
            "木"
        case .friday:
            "金"
        case .saturday:
            "土"
        }
    }
    
    var id: String {
        WeekDay(rawValue: rawValue)!.title
    }
}
