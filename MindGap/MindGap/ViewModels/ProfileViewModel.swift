import Foundation
import Combine
import SwiftData
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var userName: String = "Zack" // Dynamic later
    
    @Published var currentMoodStreak: Int = 0
    @Published var longestMoodStreak: Int = 0
    @Published var currentJournalStreak: Int = 0
    @Published var longestJournalStreak: Int = 0
    
    @Published var totalMoodCheckIns: Int = 0
    @Published var totalJournalEntries: Int = 0
    @Published var weeklyMoodValues: [Double] = []
    @Published var weeklyJournalValues: [Double] = []
    @Published var averageWeeklyMood: Double = 0.0

    private var cancellables = Set<AnyCancellable>()
    private let streakManager: StreakManager
    private let analyticsManager: AnalyticsManager

    init(streakManager: StreakManager = .shared, analyticsManager: AnalyticsManager = .shared) {
        self.streakManager = streakManager
        self.analyticsManager = analyticsManager
        
        setupBindings()
    }
    
    private func setupBindings() {
        streakManager.$currentMoodStreak
            .assign(to: &$currentMoodStreak)
        streakManager.$longestMoodStreak
            .assign(to: &$longestMoodStreak)
        streakManager.$currentJournalStreak
            .assign(to: &$currentJournalStreak)
        streakManager.$longestJournalStreak
            .assign(to: &$longestJournalStreak)
        
        analyticsManager.$totalMoodCheckIns
            .assign(to: &$totalMoodCheckIns)
        analyticsManager.$totalJournalEntries
            .assign(to: &$totalJournalEntries)
        analyticsManager.$weeklyMoodValues
            .assign(to: &$weeklyMoodValues)
        analyticsManager.$weeklyJournalValues
            .assign(to: &$weeklyJournalValues)
        analyticsManager.$averageWeeklyMood
            .assign(to: &$averageWeeklyMood)
    }

    func loadData(modelContext: ModelContext) {
        streakManager.resetStreakIfMissed() // Ensure streaks are up-to-date
        analyticsManager.setModelContext(modelContext)
        analyticsManager.fetchAnalytics()
    }
    
    var moodStreakText: String {
        "\(currentMoodStreak) Day Streak"
    }
    
    var journalStreakText: String {
        "\(currentJournalStreak) Day Streak"
    }
}
