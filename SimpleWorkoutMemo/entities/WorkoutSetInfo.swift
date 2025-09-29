//
//  WorkoutSetInfo.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/23.
//

import Foundation


struct WorkoutSetInfo: Identifiable {
    var id = UUID().uuidString
    var weight: String
    var rep: String
}
