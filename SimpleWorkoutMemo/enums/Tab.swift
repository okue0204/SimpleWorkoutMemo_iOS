//
//  ContainerTab.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/21.
//

import Foundation

enum Tab: Int {
    case home
    case calendar
    case report
    
    var title: String {
        switch self {
        case .home:
            "ホーム"
        case .calendar:
            "カレンダー"
        case .report:
            "レポート"
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            "house.fill"
        case .calendar:
            "calendar"
        case .report:
            "chart.bar.xaxis.ascending"
        }
    }
}
