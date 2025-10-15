//
//  EnvironmentConstant.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/13.
//

import Foundation

class EnvironmentConstant {
    static let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    static let privacyPolicyURL = URL(string: "https://simple-workout-privacy.web.app")!
    static let termOfServiceURL =  URL(string: "https://simple-workout-terms.web.app")!
}
