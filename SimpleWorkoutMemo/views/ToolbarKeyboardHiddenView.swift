//
//  ToolbarKeyboardHiddenView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/09.
//

import SwiftUI

struct ToolbarKeyboardHiddenView: View {
    @FocusState.Binding var isFocused: Bool
    
    let exerciseInsertHandler: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Button(action: {
                    isFocused = false
                    exerciseInsertHandler()
                }) {
                    Image(.icWorkoutAdd)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
                Button(action: {
                    isFocused = false
                }) {
                    Image(.icWorkoutHideKeyboard)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    @Previewable @FocusState var isFocused: Bool
    ToolbarKeyboardHiddenView(isFocused: $isFocused, exerciseInsertHandler: { })
}
