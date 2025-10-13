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
    let isFromHome: Bool
    let handler: ((HeaderAction?) -> Void)?
    
    var body: some View {
        if isFromHome {
            ZStack {
                Text(title)
                    .font(.semiBold(size: 20))
                    .foregroundStyle(.white)
                    .padding(.bottom, 6)
                HStack {
                    Spacer()
                    Menu {
                        Button(action: {
                            // 設定画面へ
                            handler?(.app)
                        }) {
                            HStack {
                                Text(HeaderAction.app.title)
                                Image(.icWorkoutSetting)
                                    .resizable()
                                    .frame(width: 12, height: 12)
                            }
                        }
                        Button(action: {
                            // 種目変更画面へ
                            handler?(.workout)
                        }) {
                            HStack {
                                Text(HeaderAction.workout.title)
                                Image(.icWorkoutWorkout)
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundStyle(.white)
                            }
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.blue.opacity(0.2))
                                .frame(width: 40, height: 40)
                            Image(imageResource)
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                    }
                    .padding(.trailing, 12)
                }
            }
        } else {
            ZStack {
                Text(title)
                    .font(.semiBold(size: 20))
                    .foregroundStyle(.white)
                    .padding(.bottom, 6)
                HStack {
                    Spacer()
                    Button(action: {
                        handler?(.none)
                    }) {
                        ZStack {
                            Circle()
                                .fill(.blue.opacity(0.2))
                                .frame(width: 40, height: 40)
                            Image(imageResource)
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                    }
                    .padding(.trailing, 12)
                }
            }
        }
    }
}

#Preview {
    HeaderView(title: "Today's Workout Memory",
               imageResource: .icWorkoutSetting,
               isFromHome: true) { _ in 
        
    }
}
