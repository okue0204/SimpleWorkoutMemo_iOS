//
//  VolumeReportView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/27.
//

import SwiftUI

struct VolumeReportView: View {
    @EnvironmentObject var subscription: SubscriptionManager
    @State private var isShowDetail: Bool = false
    
    let volumeReport: VolumeType
    
    var body: some View {
        Group {
            if volumeReport == .maxVolume {
                NavigationLink {
                    ReportTrendView(viewModel: ReportTrendViewModel(), volumeReport: volumeReport)
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
            } else {
                VStack(spacing: 12) {
                    HStack {
                        Text(volumeReport.title)
                            .foregroundStyle(.white)
                            .font(.regular(size: 16))
                        Spacer()
                        // No arrow for non-navigable state
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
}

#Preview {
    VolumeReportView(volumeReport: .maxVolume)
}
