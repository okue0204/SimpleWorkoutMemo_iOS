//
//  PartsItemView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/09.
//

import SwiftUI

struct PartsItemView: View {
    @Binding var scrollPosition: String?
    @Binding var selectedParts: Parts?
    let parts: Parts
    
    var body: some View {
        Button(action: {
            // 部位に対応する種目を表示する
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            selectedParts = parts
            withAnimation {
                scrollPosition = parts.id
            }
        }) {
            ZStack {
                Circle()
                    .fill(parts.color)
                    .opacity(0.6)
                    .frame(width: 50, height: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(style: .init(lineWidth: 1.5))
                            .fill(selectedParts == parts ?
                                  Color.white : Color.clear)
                    }
                Text(parts.title)
                    .font(.semiBold(size: 16))
                    .foregroundStyle(.white)
            }
            .padding(
                .trailing,
                Parts.allCases.last?.id == parts.id ? 20 : 0
            )
        }
    }
}

#Preview {
    @Previewable @State var scrollPosition: String?
    @Previewable @State var selectedParts: Parts?
    @Previewable var parts: Parts = .chest
    PartsItemView(scrollPosition: $scrollPosition, selectedParts: $selectedParts, parts: parts)
}
