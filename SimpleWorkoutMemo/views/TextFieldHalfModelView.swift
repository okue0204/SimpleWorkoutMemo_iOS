//
//  TextFieldHalfModelView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/26.
//

import SwiftUI

struct TextFieldHalfModelView: View {
    @Environment(\.dismiss) var dismiss
    @State var text: String = ""
    @FocusState var isFocused: Bool
    
    let viewModel: ReportViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 0) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("キャンセル")
                            .foregroundStyle(.white)
                            .font(.semiBold(size: 14))
                    }
                    .frame(height: 20)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    Spacer()
                    Button(action: {
                        if let targetDays = Int(text) {
                            viewModel.settingTargetDays = targetDays
                        }
                        dismiss()
                    }) {
                        Text("完了")
                            .foregroundStyle(.white)
                            .font(.semiBold(size: 14))
                    }
                    .frame(height: 20)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                Text("週のトレーニング日数")
                    .foregroundStyle(.white)
                    .font(.semiBold(size: 16))
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 12)
            TextField("日数を入力", text: $text)
                .frame(height: 40)
                .padding(.horizontal, 12)
                .keyboardType(.numberPad)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
        }
        .onAppear {
            text = String(viewModel.settingTargetDays) 
        }
    }
}

#Preview {
    TextFieldHalfModelView(viewModel: ReportViewModel())
}
