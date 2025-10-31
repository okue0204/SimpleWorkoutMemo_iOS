//
//  LineChartView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/31.
//

import SwiftUI
import Charts

struct LineChartView: View {
    
    @Binding var selectedDate: Date?
    @Binding var selectedValue: Double?
    
    private var chartColor: Color {
        selectedDate != nil ? .cyan : exercise.parts.color
    }
    
    let viewModel: ReportTrendGraphViewModel
    let exercise: Exercise
    
    var body: some View {
        Chart(viewModel.lineMarkData) { data in
            AreaMark(
                x: .value("Date",
                          data.createdAt.midDate,
                          unit: .day,
                          calendar: .autoupdatingCurrent),
                y: .value("Value", data.value)
            )
            .foregroundStyle(.linearGradient(
                .init(colors: [chartColor.opacity(0.3),
                               chartColor.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            ))
            LineMark(
                x: .value("Date",
                          data.createdAt.midDate,
                          unit: .day,
                          calendar: .autoupdatingCurrent),
                y: .value("Value", data.value)
            )
            .foregroundStyle(chartColor)
            
            if viewModel.lineMarkData.count < 100 {
                PointMark(
                    x: .value("Date", data.createdAt.midDate),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(chartColor)
                .symbol {
                    Circle()
                        .fill()
                        .frame(width: 6, height: 6)
                        .foregroundStyle(chartColor)
                }
            }
            
            if viewModel.lineMarkData.count == 1 {
                PointMark(
                    x: .value("Date", data.createdAt.midDate),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(chartColor)
            }
            if let selectedDate {
                RuleMark(x: .value("Date", selectedDate))
                    .foregroundStyle(chartColor)
            }
            
            if let selectedDate, let selectedValue, viewModel.lineMarkData.count < 50 {
                PointMark(
                    x: .value("Date", selectedDate),
                    y: .value("Value", selectedValue)
                )
                .symbol {
                    Circle()
                        .fill()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(chartColor)
                        .shadow(radius: 1)
                }
            }
        }
        .frame(height: 140)
        .padding(.bottom, 24)
        .padding(.horizontal, 12)
        .chartXSelection(value: $selectedDate)
        .chartXScale(domain: viewModel.firstLineMarkDate.midDate ... viewModel.lastLineMarkDate.midDate)
        .chartYScale(domain: 0 ... viewModel.maxLineMarkValue)
        .chartGesture { proxy in
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    proxy.selectXValue(at: value.location.x)
                }
                .onEnded { value in
                    selectedDate = nil
                    selectedValue = nil
                }
        }
        .onChange(of: selectedDate) {
            guard let selectedDate else {
                return
            }
            selectedValue = viewModel.selectedLineMarkValue(for: selectedDate)
        }
        .onChange(of: selectedValue) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}

#Preview {
    @Previewable @State var selectedDate: Date?
    @Previewable @State var selectedValue: Double?
    LineChartView(selectedDate: $selectedDate,
                  selectedValue: $selectedValue,
                  viewModel: ReportTrendGraphViewModel(),
                  exercise: .init(parts: .chest,
                                  workoutType: .freeWeight,
                                  exerciseName: "ダンベルプレス"))
}
