//
//  SelectWorkoutMenuView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/20.
//

import SwiftUI
import SwiftData

struct ExerciseId: Identifiable {
    var id: String
}

struct WorkoutListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Exercise]
    @State var viewModel: WorkoutListViewModel
    @State private var selectedParts: Parts?
    @State private var scrollPosition: String?
    @State private var text: String = ""
    @State private var selectedWorkoutType: WorkoutType = .freeWeight
    @State private var selectedExerciseId: ExerciseId?
    @FocusState private var isFocused: Bool
    var onUpdateExercise: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Parts.allCases, id: \.id) { parts in
                        ScrollView(.vertical) {
                            VStack(spacing: 12) {
                                let exercises = exercises.filter { $0.parts == parts }
                                ForEach(exercises, id: \.id) { exercise in
                                    WorkoutListItemView(selectedExerciseId: $selectedExerciseId,
                                                        viewModel: viewModel,
                                                        exercise: exercise,
                                                        onUpdateExercise: {
                                        onUpdateExercise?()
                                    })
                                    Divider()
                                        .padding(.leading, 20)
                                }
                            }
                            .padding(.top, 20)
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition)
            .onChange(of: scrollPosition) { oldValue, newValue in
                if let newValue {
                    selectedParts = Parts.allCases.first(where: { $0.rawValue == newValue }) ?? .chest
                }
            }
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(Parts.allCases, id: \.id) { parts in
                            PartsItemView(scrollPosition: $scrollPosition,
                                          selectedParts: $selectedParts,
                                          parts: parts)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                }
                .onChange(of: selectedParts) { oldValue, newValue in
                    if let newValue, selectedParts?.id == newValue.id {
                        withAnimation {
                            proxy.scrollTo(newValue.id, anchor: .trailing)
                        }
                    }
                }
            }
            SelectWorkoutTypeView(selectedWorkoutType: $selectedWorkoutType)
            SelectWorkoutMenuBottomView(isFocused: $isFocused,
                                        text: $text,
                                        selectedParts: $selectedParts,
                                        selectedWorkoutType: $selectedWorkoutType,
                                        viewModel: viewModel) {
                onUpdateExercise?()
            }
            Spacer()
        }
        .background(Color(.systemGray6))
        .onAppear {
            selectedParts = .chest
            viewModel.setContext(context: modelContext)
        }
        .sheet(item: $selectedExerciseId, content: { exerciseId in
            WorkoutSettingHalfModelView(viewModel: WorkoutSettingHalfModelViewModel(),
                                        exerciseId: exerciseId.id)
            .presentationDetents([.fraction(1/3)])
        })
    }
}

#Preview {
    WorkoutListView(viewModel: WorkoutListViewModel())
}
