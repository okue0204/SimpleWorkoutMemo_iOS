//
//  ForceUpdate.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/17.
//

import Foundation

class ForceUpdate {
    
    static let shared = ForceUpdate()
    private init() {}
    
    private func request() async -> Bool {
        guard let url = URL(string: "https://itunes.apple.com/jp/lookup?id=6754129501") else {
            return false
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            if let urlResponse = response as? HTTPURLResponse {
                switch urlResponse.statusCode {
                case 200:
                    guard let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        return false
                    }
                    if let results = jsonData["results"] as? [[String: Any]],
                       let latestVersion = results.first?["version"] as? String {
                        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                        log.debug("最新バージョン: \(latestVersion)")
                        return latestVersion != version
                    } else {
                        return false
                    }
                case 400..<500:
                    log.error("リクエストが不正です。")
                    return false
                case 500:
                    log.error("サーバーエラー")
                    return false
                default:
                    return false
                }
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func shouldUpdate() async -> Bool {
        await request()
    }
}
