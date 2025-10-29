//
//  ContainerView.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/10/21.
//

import SwiftUI

struct ContainerView: View {
    
    @State var homeViewModel = HomeViewModel()
    @State var calendarViewModel = CalendarViewModel()
    @State var reportViewModel = ReportViewModel()
    @State var selectedTab: Tab = .home
    @State var selectedDate: Date?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: homeViewModel)
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
            CalendarView(viewModel: calendarViewModel, selectedDate: $selectedDate)
                .tabItem {
                    VStack {
                        Image(systemName: Tab.calendar.imageName)
                        Text(Tab.calendar.title)
                            .font(.bold(size: 12))
                            .foregroundStyle(selectedTab == .calendar ? .blue : .gray)
                    }
                }
                .tag(Tab.calendar)
            ReportView(viewModel: reportViewModel)
                .environmentObject(AppStorageManager.shared)
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
        .onChange(of: selectedTab) { oldValue, newValue in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}

#Preview {
    ContainerView()
}
