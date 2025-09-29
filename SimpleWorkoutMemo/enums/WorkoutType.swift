//
//  WorkoutType.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/26.
//

import Foundation

enum WorkoutType: Int, Codable {
    case freeWeight = 0
    case machine
    
    var title: String {
        switch self {
        case .freeWeight:
            "free weight"
        case .machine:
            "machine"
        }
    }
}
