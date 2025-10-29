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
    @State private var scrollPosition: Int?
    @State private var currentYearDate: Date = Date()
    
    let volumeType: VolumeType
    let exercise: Exercise
    
    private var chartColor: Color {
        selectedDate != nil ? .cyan : exercise.parts.color
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(viewModel.uniqueYears, id: \.self) { _ in
                    VStack(spacing: 10) {
                        Text(exercise.exerciseName)
                            .foregroundStyle(.white)
                            .font(.regular(size: 16))
                            .padding(.top, 20)
                        if !viewModel.lineMarkData.isEmpty {
                            VStack(spacing: 0) {
                                Text(DateFormatter.dateToString(selectedDate ?? currentYearDate,
                                                                format: .yearMonthDay))
                                    .foregroundStyle(.white)
                                    .font(.medium(size: 14))
                                Text(String(selectedValue?.description ?? "0") + "kg")
                                    .foregroundStyle(.white)
                                    .font(.semiBold(size: 16))
                            }
                            .padding(.top, 6)
                        }
                        if viewModel.lineMarkData.isEmpty {
                            HStack {
                                Spacer()
                                Text("データがありません。")
                                    .foregroundStyle(.white)
                                    .font(.regular(size: 16))
                                    .frame(height: 100)
                                Spacer()
                            }
                        } else {
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
                                    
                                    if viewModel.lineMarkData.count == 1 {
                                        PointMark(
                                            x: .value("Date", data.createdAt.midDate),
                                            y: .value("Value", data.value)
                                        )
                                        .foregroundStyle(chartColor)
                                    }
                                }
                                if let selectedDate {
                                    RuleMark(x: .value("Date", selectedDate))
                                        .foregroundStyle(chartColor)
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
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $scrollPosition)
        .onAppear {
            viewModel.lineMarkData(exercise: exercise,
                                   volumeType: volumeType,
                                   workoutDays: workoutDays,
                                   targetYear: Date().year)
            viewModel.minAndMaxValue()
            viewModel.firstAndLastLineMarkDate()
            viewModel.uniqueWorkoutYears(exercise: exercise, workoutDays: workoutDays)
        }
        .onChange(of: scrollPosition) { oldValue, newValue in
            if let newValue {
                viewModel.lineMarkData(exercise: exercise,
                                       volumeType: volumeType,
                                       workoutDays: workoutDays,
                                       targetYear: newValue)
                viewModel.minAndMaxValue()
                viewModel.firstAndLastLineMarkDate()
                currentYearDate = Date.createDate(year: newValue)
            }
        }
    }
}

#Preview {
    ReportTrendGraphView(viewModel: ReportTrendGraphViewModel(),
                         volumeType: .maxVolume,
                         exercise: .init(parts: .chest,
                                         workoutType: .freeWeight,
                                         exerciseName: "ダンベルプレス"))
}
