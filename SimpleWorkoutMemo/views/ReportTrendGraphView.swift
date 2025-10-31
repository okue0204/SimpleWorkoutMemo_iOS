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
    @State private var isViewActionDisabled: Bool = false
    
    let volumeType: VolumeType
    let exercise: Exercise
    
    private var chartColor: Color {
        selectedDate != nil ? .cyan : exercise.parts.color
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.uniqueYears, id: \.self) { _ in
                    VStack(spacing: 10) {
                        ZStack {
                            Text(exercise.exerciseName)
                                .foregroundStyle(.white)
                                .font(.medium(size: 16))
                            if viewModel.uniqueYears.count > 1 {
                                HStack {
                                    if viewModel.uniqueYears.first != currentYearDate.year {
                                        Button(action: {
                                            isViewActionDisabled = true
                                            withAnimation {
                                                scrollPosition = currentYearDate.year - 1
                                            } completion: {
                                                isViewActionDisabled = false
                                            }
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundStyle(.gray.opacity(0.3))
                                                Image(.icWorkoutLeftArrow)
                                                    .resizable()
                                                    .frame(width: 14, height: 14)
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }
                                    Spacer()
                                    if viewModel.uniqueYears.last != currentYearDate.year {
                                        Button(action: {
                                            isViewActionDisabled = true
                                            withAnimation {
                                                scrollPosition =  currentYearDate.year + 1
                                            } completion: {
                                                isViewActionDisabled = false
                                            }
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundStyle(.gray.opacity(0.3))
                                                Image(.icWorkoutRightArrow)
                                                    .resizable()
                                                    .frame(width: 14, height: 14)
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 12)
                            }
                        }
                        .padding(.top, 12)
                        HStack {
                            if !viewModel.lineMarkData.isEmpty {
                                Text("\(String(viewModel.uniqueYears.first(where: { $0 == scrollPosition }) ?? Date().year))年")
                                    .foregroundStyle(.white)
                                    .font(.regular(size: 14))
                                Spacer()
                                HStack(spacing: 2) {
                                    Text(DateFormatter.dateToString(selectedDate ?? currentYearDate,
                                                                    format: .monthDay))
                                    .foregroundStyle(.white)
                                    .font(.regular(size: 14))
                                    Text(String(selectedValue?.description ?? "0") + "kg")
                                        .foregroundStyle(.white)
                                        .font(.medium(size: 14))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
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
                            LineChartView(selectedDate: $selectedDate,
                                          selectedValue: $selectedValue,
                                          viewModel: viewModel,
                                          exercise: exercise)
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
        .disabled(isViewActionDisabled)
    }
}

#Preview {
    ReportTrendGraphView(viewModel: ReportTrendGraphViewModel(),
                         volumeType: .maxVolume,
                         exercise: .init(parts: .chest,
                                         workoutType: .freeWeight,
                                         exerciseName: "ダンベルプレス"))
}
