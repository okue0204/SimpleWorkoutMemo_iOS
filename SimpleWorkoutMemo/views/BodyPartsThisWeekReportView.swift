//
//  BodyPartsReportView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/24.
//

import SwiftUI

struct BodyPartsThisWeekReportView: View {
    
    let viewModel: ReportViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(Parts.allCases, id: \.id) { parts in
                    BodyPartsThisWeekReportItemView(viewModel: viewModel, parts: parts)
                }
            }
        }
        .navigationTitle("今週の部位別レポート")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    BodyPartsThisWeekReportView(viewModel: ReportViewModel())
}
