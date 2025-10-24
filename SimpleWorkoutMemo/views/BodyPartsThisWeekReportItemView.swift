//
//  BodyPartsThisWeekReportItemView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/24.
//

import SwiftUI

struct BodyPartsThisWeekReportItemView: View {
    
    let parts: Parts
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Circle()
                    .fill(parts.color)
                    .opacity(0.6)
                    .frame(width: 30, height: 30)
                Text(parts.title)
                    .font(.semiBold(size: 20))
                    .foregroundStyle(.white)
                Spacer()
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    BodyPartsThisWeekReportItemView(parts: .chest)
}
