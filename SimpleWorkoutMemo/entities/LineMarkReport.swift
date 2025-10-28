//
//  LineMarkReport.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/27.
//

import Foundation

struct LineMarkReport: Identifiable {
    var id: String = UUID().uuidString
    let value: Double
    let createdAt: Date
}
