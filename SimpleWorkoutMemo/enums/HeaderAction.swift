//
//  ModalType.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/07.
//

import Foundation
import SwiftUI

enum HeaderAction: String, Identifiable, View {
    case app
    case workout
    
    var id: String {
        rawValue
    }
    
    var body: some View {
        switch self {
        case .app:
            AnyView(SettingView())
        case .workout:
            AnyView(WorkoutListView(viewModel: WorkoutListViewModel()))
        }
    }
    
    var title: String {
        switch self {
        case .app:
            "設定"
        case .workout:
            "種目"
        }
    }
}
