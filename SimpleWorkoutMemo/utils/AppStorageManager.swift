//
//  AppStorageManager.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/28.
//

import Foundation
import SwiftUI

class AppStorageManager: ObservableObject {
    
    private init() {}
    static let shared = AppStorageManager()
    
    @AppStorage("isFirstTimeAppLaunch") var isFirstTimeAppLaunch: Bool = true
    @AppStorage("isShowLastTimeAppLaunch") var isShowLastTimeAppLaunch = true
    @AppStorage("appLaunchCount") var appLaunchCount: Int = 0
    @AppStorage("lastUpdateDate") var lastUpdateDate: Date?
}
