//
//  CalendarItemView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/16.
//

import SwiftUI

struct CalendarItemView: View {
    @Binding var selectedDate: Date?
    
    private static let maxWorkoutCount: Int = 4
    
    let date: Date
    let workoutDay: WorkoutDay?
    let isCurrentMonth: Bool
    
    var textWidth: CGFloat {
        (UIScreen.main.bounds.width) / 7
    }
    
    var body: some View {
        Button(action: {
            selectedDate = date
        }) {
            VStack(alignment: .center, spacing: 2) {
                Text("\(date.day)")
                    .font(.regular(size: 16))
                    .frame(width: textWidth)
                    .foregroundStyle(.white)
                LazyVGrid(
                    columns: Array(repeating: .init(spacing: 0), count: 2),
                    spacing: 4
                ) {
                    if let workoutDay {
                        ForEach(workoutDay.workouts.prefix(4), id: \.id) { workout in
                            if let exercise = workout.exercise {
                                ZStack {
                                    Circle()
                                        .fill(exercise.parts.color.opacity(0.5))
                                        .frame(width: 24, height: 24)
                                    Text(exercise.parts.title)
                                        .foregroundStyle(.white)
                                        .font(.semiBold(size: 10))
                                }
                            }
                        }
                    } else {
                        EmptyView()
                    }
                }
                if let workoutDay,
                   workoutDay.createdAt.zeroClock == date.zeroClock,
                   workoutDay.workouts.count > Self.maxWorkoutCount {
                    Text("+ \(workoutDay.workouts.count - Self.maxWorkoutCount)")
                        .foregroundStyle(.gray)
                        .font(.regular(size: 12))
                }
                Spacer()
            }
        }
        .frame(height: 100)
        .padding(.bottom, 2)
        .background(date.zeroClock == selectedDate?.zeroClock ?
                    Color.cyan.opacity(0.2) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    @Previewable @State var selectedDate: Date? = Date()
    CalendarItemView(selectedDate: $selectedDate,
                     date: Date(),
                     workoutDay: nil,
                     isCurrentMonth: true)
}
