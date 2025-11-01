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
    
    @Namespace private var namespace
    
    var viewModel: CalendarViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            Text(DateFormatter.dateToString(currentPositionDate ?? Date(), format: .yearMonth))
                .foregroundStyle(.white)
                .font(.bold(size: 20))
            Spacer()
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                let calendarMonth = viewModel.todayCalendarMonth()
                currentPositionDate = calendarMonth.date.zeroClock
                withAnimation {
                    scrollPosition = calendarMonth.id
                }
            }) {
                todayButton()
            }
            selectedDateContent()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private func todayButton() -> some View {
        if #available(iOS 26.0, *) {
            Text("今日")
                .foregroundStyle(.white)
                .font(.medium(size: 18))
                .frame(height: 40)
                .padding(.horizontal, 20)
                .glassEffect()
        } else {
            Text("今日")
                .foregroundStyle(.blue)
                .font(.medium(size: 18))
                .padding(.horizontal, 12)
                .frame(height: 40)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.trailing, 20)
        }
    }
    
    @ViewBuilder
    private func selectedDateContent() -> some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                HStack(spacing: 0) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
                            .frame(width: 14, height: 14)
                            .padding(.horizontal, 16)
                            .frame(height: 40)
                            .foregroundStyle(.white)
                            .glassEffect()
                            .glassEffectUnion(id: "selectedDate",
                                              namespace: namespace)
                    }
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
                            .frame(width: 14, height: 14)
                            .padding(.horizontal, 16)
                            .frame(height: 40)
                            .foregroundStyle(.white)
                            .glassEffect()
                            .glassEffectUnion(id: "selectedDate",
                                              namespace: namespace)
                    }
                }
                .padding(.horizontal, 12)
            }
        } else {
            HStack(spacing: 28) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
            .padding(.horizontal, 12)
            .frame(height: 40)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    @Previewable @State var currentPositionDate: Date? = Date()
    @Previewable @State var scrollPosition: String? = nil
    CurrentCalendarSelectTextView(currentPositionDate: $currentPositionDate,
                                  scrollPosition: $scrollPosition,
                                  viewModel: CalendarViewModel())
}
