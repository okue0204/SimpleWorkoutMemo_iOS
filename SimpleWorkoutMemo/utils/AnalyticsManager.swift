//
//  AnalyticsManager.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/14.
//

import Foundation
import SwiftUI
import FirebaseAnalytics

class AnalyticsManager {
    
    enum Event: String {
        case addWorkout
        case removeWorkout
        case editWorkout
        case showCalendar
        case showWorkoutList
        case showReview
        case showShare
    }
    
    static func logEvent(_ event: AnalyticsManager.Event) {
        Analytics.logEvent(event.rawValue, parameters: [:])
    }
}
