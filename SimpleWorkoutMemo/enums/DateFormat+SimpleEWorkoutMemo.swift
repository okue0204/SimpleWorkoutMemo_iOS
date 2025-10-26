//
//  DateFormat+SimpleEWorkoutMemo.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/20.
//

import Foundation

enum DateFormat {
    case yearMonthDay
    case yearMonth
    case monthDay
    case year
    
    var formatString: String {
        switch self {
        case .yearMonthDay:
            "yyyy年MM月dd日"
        case .yearMonth:
            "yyyy年MM月"
        case .monthDay:
            "MM月dd日"
        case .year:
            "yyyy年"
        }
    }
}
