//
//  AppOpenAdManager.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/17.
//

import Foundation
import GoogleMobileAds
import SwiftUI
import SwiftyBeaver

@MainActor
class AppOpenAdManager: NSObject, ObservableObject {
    
    @Published var appOpenAdLoaded: Bool = false
    @Published var adDismissed: Bool = false
    var appOpenAd: AppOpenAd?
    
    func loadAd() async {
        do {
            appOpenAd = try await AppOpenAd.load(with: "EnvironmentConstant.adOpenId", request: Request())
            appOpenAd?.fullScreenContentDelegate = self
            appOpenAdLoaded = true
        } catch {
            log.error("failed to load app open ad: \(error.localizedDescription)")
        }
    }
    
    func presentAppOpenAd() {
        guard let appOpenAd,
              let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        appOpenAd.present(from: scene.windows.first?.rootViewController)
    }
}

extension AppOpenAdManager: FullScreenContentDelegate {
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Task {
            await loadAd()
        }
        print("😭: エラー -> \(error)")
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        Task {
            await loadAd()
        }
        adDismissed.toggle()
        print("🍅: 閉じました")
    }
}
