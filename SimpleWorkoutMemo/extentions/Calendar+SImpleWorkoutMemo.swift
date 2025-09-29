//
//  Calendar+SImpleWorkoutMemo.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/27.
//

import Foundation
import SwiftUI

extension Calendar {
    static var appCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .japan
        calendar.locale = .japan
        return calendar
    }
}
