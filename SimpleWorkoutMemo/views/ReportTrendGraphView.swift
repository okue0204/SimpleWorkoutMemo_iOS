//
//  ReportTrendGraphView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/27.
//

import SwiftUI
import Charts
import SwiftData

struct ReportTrendGraphView: View {
    
    @Query var workoutDays: [WorkoutDay]
    @State var viewModel: ReportTrendGraphViewModel
    @State private var isHideBanner: Bool = false
    @State private var selectedDate: Date?
    @State private var selectedValue: Double?
    @State private var isShowDefaultPointMark: Bool = true
    
    let volumeType: VolumeType
    let exercise: Exercise
    
    private var chartColor: Color {
        selectedDate != nil ? .cyan : exercise.parts.color
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(exercise.exerciseName)
                .foregroundStyle(.white)
                .font(.medium(size: 16))
                .padding(.top, 20)
            Chart {
                ForEach(viewModel.lineMarkData, id: \.id) { data in
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
                    if isShowDefaultPointMark {
                        PointMark(
                            x: .value("Date", data.createdAt.midDate),
                            y: .value("Value", data.value)
                        )
                        .symbol {
                            Circle()
                                .fill()
                                .frame(width: 6, height: 6)
                                .foregroundStyle(chartColor)
                                .shadow(radius: 1)
                        }
                    }
                    
                    if let selectedDate {
                        RuleMark(x: .value("Date", selectedDate))
                            .foregroundStyle(chartColor)
                            .annotation(position: .top) {
                                VStack(spacing: 0) {
                                    Text(DateFormatter.dateToString(selectedDate, format: .yearMonthDay))
                                        .foregroundStyle(.white)
                                        .font(.regular(size: 12))
                                    Text(String(selectedValue?.description ?? "??") + "kg")
                                        .foregroundStyle(.white)
                                        .font(.regular(size: 12))
                                }
                            }
                    }
                    if let selectedDate, let selectedValue {
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
            }
            .frame(height: 160)
            .padding(.vertical, 24)
            .padding(.horizontal, 12)
            .chartXSelection(value: $selectedDate)
            .chartXScale(domain: viewModel.firstLineMarkDate.midDate ... viewModel.lastLineMarkDate.midDate)
            .chartYScale(domain: 0 ... viewModel.maxLineMarkValue)
            .chartGesture { proxy in
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        proxy.selectXValue(at: value.location.x)
                        isShowDefaultPointMark = false
                    }
                    .onEnded { value in
                        selectedDate = nil
                        selectedValue = nil
                        isShowDefaultPointMark = true
                    }
            }
            .onAppear(perform: {
                viewModel.lineMarkData(exercise: exercise,
                                       volumeType: volumeType,
                                       workoutDays: workoutDays)
                viewModel.minAndMaxValue()
                viewModel.firstAndLastLineMarkDate()
            })
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
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ReportTrendGraphView(viewModel: ReportTrendGraphViewModel(),
                         volumeType: .maxVolume,
                         exercise: .init(parts: .chest,
                                         workoutType: .freeWeight,
                                         exerciseName: "ダンベルプレス"))
}
