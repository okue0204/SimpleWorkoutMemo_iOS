//
//  Date+SimpleWorkoutMemo.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/27.
//

import Foundation
import SwiftUI

extension Date {
    
    var zeroClock: Date {
        let dateComponent = DateComponents(calendar: .appCalendar, year: year, month: month, day: day)
        return dateComponent.date ?? Date()
    }
    
    var year: Int {
        Calendar.appCalendar.component(.year, from: self)
    }
    
    var month: Int {
        Calendar.appCalendar.component(.month, from: self)
    }
    
    var day: Int {
        Calendar.appCalendar.component(.day, from: self)
    }
    
    func addDay(_ value: Int) -> Date {
        Calendar.appCalendar.date(byAdding: .day, value: value, to: self) ?? Date()
    }
}
