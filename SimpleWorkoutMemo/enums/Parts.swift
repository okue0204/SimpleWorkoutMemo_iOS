//
//  Parts.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/20.
//

import Foundation
import SwiftUI

enum Parts: String, CaseIterable, Identifiable, Codable {
    case chest
    case back
    case biceps
    case triceps
    case forearm
    case shoulders
    case legs
    case abs
    
    var title: String {
        switch self {
        case .chest:
            "胸"
        case .back:
            "背中"
        case .biceps:
            "二頭"
        case .triceps:
            "三頭"
        case .forearm:
            "前腕"
        case .shoulders:
            "肩"
        case .legs:
            "脚"
        case .abs:
            "腹筋"
        }
    }
    
    var color: Color {
        switch self {
        case .chest:
                .red
        case .back:
                .blue
        case .biceps:
                .green
        case .triceps:
                .orange
        case .forearm:
                .yellow
        case .shoulders:
                .purple
        case .legs:
                .brown
        case .abs:
                .teal
        }
    }
    
    var id: String {
        rawValue
    }
}
