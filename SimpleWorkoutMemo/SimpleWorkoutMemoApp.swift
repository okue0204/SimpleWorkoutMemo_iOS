//
//  SimpleWorkoutMemoApp.swift
//  SimpleWorkoutMemo
//
//  Created by 奥江英隆 on 2025/09/20.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct SimpleWorkoutMemoApp: App {
    
    @UIApplicationDelegateAdaptor (AppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WorkoutDay.self,
            Exercise.self,
            WorkoutSetInfo.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        @State var viewModel = HomeViewModel()
        WindowGroup {
            HomeView(viewModel: viewModel)
                .preferredColorScheme(.dark)
                .environmentObject(AppStorageManager.shared)
        }
        .modelContainer(sharedModelContainer)
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
