//
//  ContainerView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/21.
//

import SwiftUI

struct ContainerView: View {
    
    @State var viewModel = HomeViewModel()
    @State var selectedTab: Tab = .home
    @State var selectedDate: Date?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel)
                .environmentObject(AppStorageManager.shared)
                .tabItem {
                    VStack {
                        Image(systemName: Tab.home.imageName)
                        Text(Tab.home.title)
                            .font(.bold(size: 12))
                            .foregroundStyle(selectedTab == .home ? .blue : .gray)
                    }
                }
                .tag(Tab.home)
            CalendarView(viewModel: CalendarViewModel(), selectedDate: $selectedDate)
                .tabItem {
                    VStack {
                        Image(systemName: Tab.calendar.imageName)
                        Text(Tab.calendar.title)
                            .font(.bold(size: 12))
                            .foregroundStyle(selectedTab == .report ? .blue : .gray)
                    }
                }
            ReportView(viewModel: ReportViewModel())
                .tabItem {
                    VStack {
                        Image(systemName: Tab.report.imageName)
                        Text(Tab.report.title)
                            .font(.bold(size: 12))
                            .foregroundStyle(selectedTab == .report ? .blue : .gray)
                    }
                }
                .tag(Tab.report)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContainerView()
}
