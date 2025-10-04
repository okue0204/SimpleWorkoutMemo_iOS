//
//  CalendarViewModel.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/04.
//

import Foundation
import SwiftUI
import Observation

@Observable
class CalendarViewModel {
    
    // 現在から未来100年のdateの配列
    var calendars: [CalendarMonth] = []
    
    func createCalendarMonth() {
        calendars = (0...100).map { int in
            CalendarMonth(
                id: UUID().uuidString,
                date: Date().addMonth(int)
            )
        }
    }
}
