import SwiftUI

@main
struct MindGapApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var showSplash: Bool = true

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView(showSplash: $showSplash)
            } else if hasSeenOnboarding {
                LaunchView()
            } else {
                OnboardingView()
            }
        }
    }
}