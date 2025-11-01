//
//  SelectWorkoutTypeView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/09.
//

import SwiftUI

struct SelectWorkoutTypeView: View {
    @Binding var selectedWorkoutType: WorkoutType?
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                selectedWorkoutType = .freeWeight
            } label: {
                HStack(spacing: 8) {
                    let image: ImageResource = if let selectedWorkoutType {
                        selectedWorkoutType == .freeWeight ? .icWorkoutCheckCircle : .icWorkoutCircle
                    } else {
                        .icWorkoutCircle
                    }
                    Image(image)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    Text("フリーウェイト")
                        .font(.regular(size: 14))
                        .foregroundStyle(.white)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                let color: Color = if let selectedWorkoutType {
                    selectedWorkoutType == .freeWeight ? .yellow : .clear
                } else {
                    .clear
                }
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color, lineWidth: 2)
            }
            Spacer()
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                selectedWorkoutType = .machine
            } label: {
                HStack(spacing: 8) {
                    let image: ImageResource = if let selectedWorkoutType {
                        selectedWorkoutType == .machine ? .icWorkoutCheckCircle : .icWorkoutCircle
                    } else {
                        .icWorkoutCircle
                    }
                    Image(image)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    Text("マシン")
                        .font(.regular(size: 14))
                        .foregroundStyle(.white)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                let color: Color = if let selectedWorkoutType {
                    selectedWorkoutType == .machine ? .yellow : .clear
                } else {
                    .clear
                }
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color, lineWidth: 2)
            }
            Spacer()
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                selectedWorkoutType = .bodyweight
            } label: {
                HStack(spacing: 8) {
                    let image: ImageResource = if let selectedWorkoutType {
                        selectedWorkoutType == .bodyweight ? .icWorkoutCheckCircle : .icWorkoutCircle
                    } else {
                        .icWorkoutCircle
                    }
                    Image(image)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    Text("自重")
                        .font(.regular(size: 14))
                        .foregroundStyle(.white)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                let color: Color = if let selectedWorkoutType {
                    selectedWorkoutType == .bodyweight ? .yellow : .clear
                } else {
                    .clear
                }
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color, lineWidth: 2)
            }
            Spacer()
        }
        .frame(height: 40)
        .padding(.horizontal, 6)
        .padding(.bottom, 12)
    }
}

#Preview {
    @Previewable @State var selectedWorkoutType: WorkoutType?
    SelectWorkoutTypeView(selectedWorkoutType: $selectedWorkoutType)
}
