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
    static let showAdOpenLimitCount = 5
    static let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id6754129501")!
    
    #if DEBUG
    static let bannerId = "ca-app-pub-3940256099942544/2435281174"
    static let interstitialId = "ca-app-pub-3940256099942544/4411468910"
    static let adOpenId = "ca-app-pub-3940256099942544/5575463023"
    #elseif PRODUCTION
    static let bannerId = "ca-app-pub-6663259427797114/7797007267"
    static let interstitialId = "ca-app-pub-6663259427797114/4280240568"
    static let adOpenId = "ca-app-pub-6663259427797114/3154667637"
    #endif
}
