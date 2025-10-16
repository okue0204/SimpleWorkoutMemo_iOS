//
//  WeekDayView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/16.
//

import SwiftUI

struct WeekDayView: View {
    var body: some View {
        HStack {
            ForEach(WeekDay.allCases) { weekDay in
                switch weekDay {
                case .saturday, .sunday:
                    Text(weekDay.title)
                        .foregroundStyle(.gray)
                        .font(.semiBold(size: 14))
                        .frame(maxWidth: .infinity)
                default:
                    Text(weekDay.title)
                        .foregroundStyle(.white)
                        .font(.semiBold(size: 14))
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
    }
}

#Preview {
    WeekDayView()
}
