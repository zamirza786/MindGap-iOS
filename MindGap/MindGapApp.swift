import SwiftUI
import SwiftData

@main
struct MindGapApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var showSplash: Bool = true
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashView(showSplash: $showSplash)
                } else if hasSeenOnboarding {
                    LaunchView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.colorScheme)
            .onAppear {
                ReminderManager.shared.requestPermission()
            }
        }
        .modelContainer(for: [JournalEntry.self, Goal.self])
    }
}