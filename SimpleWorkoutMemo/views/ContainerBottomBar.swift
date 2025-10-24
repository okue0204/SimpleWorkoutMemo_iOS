//
//  ContainerBottomBar.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/21.
//

import SwiftUI

struct ContainerBottomBar: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            Button(action: {
                selectedTab = .home
                print("++++ tap home button")
            }) {
                VStack(spacing: 4) {
                    Image(.icWorkoutHome)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("ワークアウト")
                        .font(.bold(size: 12))
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(selectedTab == .home ? .blue: .gray)
            }
            Button(action: {
                selectedTab = .report
                print("++++ tap home button")
            }) {
                VStack(spacing: 4) {
                    Image(.icWorkoutReport)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("レポート")
                        .font(.bold(size: 12))
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(selectedTab == .report ? .blue: .gray)
            }
        }
        .frame(height: 60)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal, 12)
    }
}

#Preview {
    @Previewable @State var selectedTab: Tab = .home
    ContainerBottomBar(selectedTab: $selectedTab)
}
