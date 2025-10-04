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
    
    var formatString: String {
        switch self {
        case .yearMonthDay:
            "yyyy年MM月dd日"
        case .yearMonth:
            "yyyy年MM月"
        }
    }
}
