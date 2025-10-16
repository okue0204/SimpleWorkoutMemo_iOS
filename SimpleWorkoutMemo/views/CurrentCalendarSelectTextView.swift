//
//  CurrentCalendarSelectTextView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/16.
//

import SwiftUI

struct CurrentCalendarSelectTextView : View {
    
    @Binding var currentPositionDate: Date?
    @Binding var scrollPosition: String?
    
    var viewModel: CalendarViewModel
    
    var body: some View {
        HStack {
            Text(DateFormatter.dateToString(currentPositionDate ?? Date(), format: .yearMonth))
                .foregroundStyle(.white)
                .font(.bold(size: 24))
            Spacer()
            HStack(spacing: 30) {
                Button(action: {
                    // 先月
                    let date = if let currentPositionDate {
                        currentPositionDate.addMonth(-1).onlyYearAndMonth
                    } else {
                        Date().onlyYearAndMonth
                    }
                    let calendarMonth = viewModel.lastMonthCalendarMonth(for: date)
                    currentPositionDate = calendarMonth?.date.zeroClock
                    withAnimation {
                        scrollPosition = calendarMonth?.id
                    }
                }) {
                    Image(.icWorkoutLeftArrow)
                        .resizable()
                        .frame(width: 18, height: 18)
                }
                Button(action: {
                    // 来月
                    let date = if let currentPositionDate {
                        currentPositionDate.onlyYearAndMonth
                    } else {
                        Date().onlyYearAndMonth
                    }
                    let calendarMonth = viewModel.nextMonthCalendarMonth(for: date)
                    currentPositionDate = calendarMonth.date.zeroClock
                    withAnimation {
                        scrollPosition = calendarMonth.id
                    }
                }) {
                    Image(.icWorkoutRightArrow)
                        .resizable()
                        .frame(width: 18, height: 18)
                }
            }
            .padding(.trailing, 30)
        }
        .padding(.leading, 20)
        .padding(.bottom, 4)
    }
}

#Preview {
    @Previewable @State var currentPositionDate: Date? = Date()
    @Previewable @State var scrollPosition: String? = nil
    CurrentCalendarSelectTextView(currentPositionDate: $currentPositionDate,
                                  scrollPosition: $scrollPosition,
                                  viewModel: CalendarViewModel())
}
