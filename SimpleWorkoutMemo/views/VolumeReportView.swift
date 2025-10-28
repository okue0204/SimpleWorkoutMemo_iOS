//
//  VolumeReportView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/27.
//

import SwiftUI

struct VolumeReportView: View {
     
    let volumeReport: VolumeType
    
    var body: some View {
        NavigationLink {
            switch volumeReport {
            case .maxVolume:
                ReportTrendView(viewModel: ReportTrendViewModel(), volumeReport: volumeReport)
            case .totalVolume:
                EmptyView()
            }
        } label: {
            VStack(spacing: 12) {
                HStack {
                    Text(volumeReport.title)
                        .foregroundStyle(.white)
                        .font(.regular(size: 16))
                    Spacer()
                    Image(.icWorkoutRightArrow)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 20)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Parts.allCases, id: \.id) { parts in
                            VolumeReportItemView(viewModel: VolumeReportItemViewModel(),
                                                 parts: parts,
                                                 volumeReport: volumeReport)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

#Preview {
    VolumeReportView(volumeReport: .maxVolume)
}
