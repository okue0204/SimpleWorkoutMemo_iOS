//
//  DateFormatter+SimpleWorkoutMemo.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/20.
//

import Foundation
import SwiftUI

extension DateFormatter {
    static func dateToString(_ date: Date, format: DateFormat = .yearMonthDay) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.formatString
        formatter.timeZone = .japan
        formatter.locale = .japan
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.string(from: date)
    }
}
