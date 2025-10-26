//
//  BarMarkReport.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/25.
//

import Foundation

struct BarMarkReport: Identifiable {
    var id: String = UUID().uuidString
    let period: Periodable
    let value: Int
    let category: BarMarkReportCategory
}

enum BarMarkReportCategory {
    case set
    case rep
    case totalLoad
    
    var title: String {
        switch self {
        case .set:
            "セット"
        case .rep:
            "レップ"
        case .totalLoad:
            "総負荷量"
        }
    }
}
