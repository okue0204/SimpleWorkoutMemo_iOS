//
//  WebView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/15.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL
    
    typealias UIViewType = WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
