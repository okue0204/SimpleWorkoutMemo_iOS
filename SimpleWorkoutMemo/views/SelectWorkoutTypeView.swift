//
//  SelectWorkoutTypeView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/09.
//

import SwiftUI

struct SelectWorkoutTypeView: View {
    @Binding var selectedWorkoutType: WorkoutType
    var body: some View {
        HStack(spacing: 14) {
            Button {
                selectedWorkoutType = .freeWeight
            } label: {
                HStack(spacing: 8) {
                    Image(selectedWorkoutType == .freeWeight ? .icWorkoutCheckCircle : .icWorkoutCircle)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    Text("フリーウェイト")
                        .font(.regular(size: 14))
                        .foregroundStyle(.white)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(selectedWorkoutType == .freeWeight ? .yellow : .clear, lineWidth: 2)
            }
            Button {
                selectedWorkoutType = .machine
            } label: {
                HStack(spacing: 8) {
                    Image(selectedWorkoutType == .machine ? .icWorkoutCheckCircle : .icWorkoutCircle)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    Text("マシン")
                        .font(.regular(size: 14))
                        .foregroundStyle(.white)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(selectedWorkoutType == .machine ? .yellow : .clear, lineWidth: 2)
            }
            Button {
                selectedWorkoutType = .bodyweight
            } label: {
                HStack(spacing: 8) {
                    Image(selectedWorkoutType == .bodyweight ? .icWorkoutCheckCircle : .icWorkoutCircle)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    Text("自重")
                        .font(.regular(size: 14))
                        .foregroundStyle(.white)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(selectedWorkoutType == .bodyweight ? .yellow : .clear, lineWidth: 2)
            }
            Spacer()
        }
        .frame(height: 40)
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
        .onAppear {
            selectedWorkoutType = .freeWeight
        }
    }
}

#Preview {
    @Previewable @State var selectedWorkoutType: WorkoutType = .freeWeight
    SelectWorkoutTypeView(selectedWorkoutType: $selectedWorkoutType)
}
