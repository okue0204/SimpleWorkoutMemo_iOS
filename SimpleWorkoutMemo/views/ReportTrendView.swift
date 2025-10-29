//
//  ReportTrendGraphView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/27.
//

import SwiftUI
import SwiftData

struct ReportTrendView: View {
    @Query var exercises: [Exercise]
    
    @State var viewModel: ReportTrendViewModel
    @State private var isHideBanner: Bool = false
    @State private var selectedParts: Parts?
    @State private var scrollPosition: String?
    
    let volumeReport: VolumeType
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    ForEach(viewModel.exercises, id: \.id) { exercise in
                        ReportTrendGraphView(viewModel: ReportTrendGraphViewModel(),
                                             volumeType: volumeReport,
                                             exercise: exercise)
                    }
                }
                .padding(.horizontal, 20)
            }
            Spacer()
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
                        viewModel.filterExercise(for: newValue, exercises: exercises)
                        withAnimation {
                            proxy.scrollTo(newValue.id, anchor: .trailing)
                        }
                    }
                }
            }
        }
        .navigationTitle("種目別最大重量")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedParts = .chest
            viewModel.filterExercise(for: .chest, exercises: exercises)
        }
    }
}

#Preview {
    @Previewable @State var viewModel = ReportTrendViewModel()
    ReportTrendView(viewModel: viewModel, volumeReport: .maxVolume)
}
