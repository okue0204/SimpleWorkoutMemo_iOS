//
//  BannerViewContainer.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/17.
//

import Foundation
import SwiftUI
import GoogleMobileAds

struct BannerViewContainer: UIViewRepresentable {
    typealias UIViewType = BannerView
    
    var errorHandler: (() -> Void)?
    
    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView()
        bannerView.adUnitID = EnvironmentConstant.bannerId
        bannerView.load(Request())
        bannerView.delegate = context.coordinator
        return bannerView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> BannerCoordinator {
        BannerCoordinator(self) {
            errorHandler?()
        }
    }
}

class BannerCoordinator: NSObject, BannerViewDelegate {
    
    let parent: BannerViewContainer
    
    var errorHandler: (() -> Void)?
    
    init(_ parent: BannerViewContainer, handler: (() -> Void)?) {
        self.errorHandler = handler
        self.parent = parent
    }
    
    // MARK: - GADBannerViewDelegate methods
    
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("DID RECEIVE AD.")
    }
    
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        errorHandler?()
        log.error(error.localizedDescription)
    }
}
