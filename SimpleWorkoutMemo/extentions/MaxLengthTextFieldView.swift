//
//  MaxLengthTextField.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/21.
//

import Foundation
import SwiftUI

struct MaxLengthTextFieldView: View {
    
    @State var workoutSetInfo: WorkoutSetInfo
    @FocusState.Binding var focusedField: FocusField?
    
    let workoutInputType: WorkoutInputType
    let onUpdateSetInfo: (WorkoutSetInfo) -> Void
    
    private static let maxLength: Int = 5
    
    var body: some View {
        let focusField: FocusField = .init(id: workoutSetInfo.id)
        TextField("0", text: workoutInputType == .weight ? $workoutSetInfo.weight : $workoutSetInfo.rep)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .keyboardType(workoutInputType == .weight ? .decimalPad : .numberPad)
            .font(.regular(size: 16))
            .focused($focusedField, equals: focusField)
            .frame(minWidth: 50)
            .contentShape(.rect)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onChange(of: workoutInputType == .weight ? workoutSetInfo.weight : workoutSetInfo.rep) { oldValue, newValue in
                if newValue.count <= Self.maxLength {
                    if workoutInputType == .weight {
                        workoutSetInfo.weight = String(newValue.prefix(Self.maxLength))
                    } else {
                        workoutSetInfo.rep = String(newValue.prefix(Self.maxLength))
                    }
                    onUpdateSetInfo(workoutSetInfo)
                }
            }
            .onTapGesture {
                focusedField = focusField
            }
    }
}
