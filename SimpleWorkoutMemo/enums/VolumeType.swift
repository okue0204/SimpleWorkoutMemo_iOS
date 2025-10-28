//
//  VolumeReport.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/27.
//

import Foundation

enum VolumeType {
    case maxVolume
    case totalVolume
    
    var title: String {
        switch self {
        case .maxVolume:
            "種目別最大重量"
        case .totalVolume:
            "部位別トータルボリューム"
        }
    }
}
