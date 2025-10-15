//
//  ShareItem.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/15.
//

import Foundation
import SwiftUI

struct ShareItem: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }
    
    let url: URL
    let text: String
    let image: Image
}
