//
//  SelectWorkoutMenuView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/20.
//

import SwiftUI

struct SelectWorkoutMenuView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedParts: Parts?
    @State private var scrollPosition: String?
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "種目の選択",
                       imageResource: .icWorkoutClose) {
                dismiss()
            }
                       .padding(.vertical, 20)
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(Parts.allCases, id: \.id) { parts in
                            Button(action: {
                                // 部位に対応する種目を表示する
                                selectedParts = parts
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
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                }
                .onChange(of: selectedParts) { oldValue, newValue in
                    if let newValue, selectedParts?.id == newValue.id {
                        withAnimation {
                            proxy.scrollTo(newValue.id, anchor: .trailing)
                        }
                    }
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Parts.allCases, id: \.id) { parts in
                        ScrollView(.vertical) {
                            VStack(spacing: 12) {
                                ForEach(0..<10) { num in
                                    HStack {
                                        Button(action: {
                                            
                                        }) {
                                            HStack {
                                                Text("ベンチプレス")
                                                    .font(.semiBold(size: 20))
                                                    .foregroundStyle(.white)
                                                Spacer()
                                            }
                                        }
                                        .contentShape(.rect)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    Divider()
                                        .padding(.leading, 20)
                                }
                            }
                            .padding(.top, 20)
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition)
            .onChange(of: scrollPosition) { oldValue, newValue in
                if let newValue {
                    selectedParts = Parts.allCases.first(where: { $0.rawValue == newValue }) ?? .chest
                }
            }
            Spacer()
        }
        .background(Color(.systemGray6))
        .onAppear {
            selectedParts = .chest
        }
    }
}

#Preview {
    SelectWorkoutMenuView()
}
