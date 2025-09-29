//
//  Font+SimpleWorkoutMemo.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/20.
//

import Foundation
import SwiftUI

extension Font {
    static func bold(size: CGFloat) -> Font {
        .custom("NotoSansJP-Bold", size: size)
    }
    static func semiBold(size: CGFloat) -> Font {
        .custom("NotoSansJP-SemiBold", size: size)
    }
    static func medium(size: CGFloat) -> Font {
        .custom("NotoSansJP-Medium", size: size)
    }
    static func regular(size: CGFloat) -> Font {
        .custom("NotoSansJP-Regular", size: size)
    }
    static func light(size: CGFloat) -> Font {
        .custom("NotoSansJP-Light", size: size)
    }
}
