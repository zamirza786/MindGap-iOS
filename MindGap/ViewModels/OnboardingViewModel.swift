import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPageIndex: Int = 0
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to MindGap",
            description: "Your personal guide to mental clarity and emotional well-being.",
            imageName: "onboarding_illustration_1"
        ),
        OnboardingPage(
            title: "Journal Your Thoughts",
            description: "Reflect on your day, track your moods, and gain insights into your emotional patterns.",
            imageName: "onboarding_illustration_2"
        ),
        OnboardingPage(
            title: "Guided Reflection",
            description: "Discover guided prompts and exercises to foster self-awareness and personal growth.",
            imageName: "onboarding_illustration_3"
        ),
        OnboardingPage(
            title: "Find Your Balance",
            description: "Achieve mental clarity and a balanced mind with MindGap's intuitive tools.",
            imageName: "onboarding_illustration_4"
        )
    ]

    var currentPage: OnboardingPage {
        pages[currentPageIndex]
    }

    var isLastPage: Bool {
        currentPageIndex == pages.count - 1
    }

    func goToNextPage() {
        if !isLastPage {
            currentPageIndex += 1
        }
    }

    func skipOnboarding() {
        hasSeenOnboarding = true
    }

    func getStarted() {
        hasSeenOnboarding = true
    }
}
