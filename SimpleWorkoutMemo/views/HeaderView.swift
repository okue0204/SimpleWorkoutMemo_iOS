//
//  HeaderView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/21.
//

import SwiftUI

struct HeaderView: View {
    
    let title: String
    let imageResource: ImageResource
    let handler: (() -> Void)?
    
    var body: some View {
        ZStack {
            Text(title)
                .font(.semiBold(size: 20))
                .foregroundStyle(.white)
                .padding(.bottom, 6)
            HStack {
                Spacer()
                Button(action: {
                    handler?()
                }) {
                    ZStack {
                        Circle()
                            .fill(.blue.opacity(0.2))
                            .frame(width: 40, height: 40)
                        Image(imageResource)
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.trailing, 12)
            }
        }
    }
}

#Preview {
    HeaderView(title: "Today's Workout Memory",
               imageResource: .icWorkoutSetting) {
        
    }
}
