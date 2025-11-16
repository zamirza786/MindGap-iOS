import Foundation
import SwiftData

class AnalyticsManager: ObservableObject {
    static let shared = AnalyticsManager()
    
    @Published var totalMoodCheckIns: Int = 0
    @Published var totalJournalEntries: Int = 0
    @Published var weeklyMoodValues: [Double] = Array(repeating: 0.0, count: 7) // Placeholder for 7 days
    @Published var weeklyJournalValues: [Double] = Array(repeating: 0.0, count: 7) // Placeholder for 7 days
    @Published var averageWeeklyMood: Double = 0.0

    private var modelContext: ModelContext? // Will be set from environment

    private init() {}

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        fetchAnalytics()
    }

    func fetchAnalytics() {
        guard let context = modelContext else { return }

        // Total Journal Entries
        do {
            let descriptor = FetchDescriptor<JournalEntry>()
            totalJournalEntries = try context.fetchCount(descriptor)
        } catch {
            print("Failed to fetch total journal entries: \(error)")
        }

        // Total Mood Check-ins (Placeholder for now, will integrate with Mood model later)
        // For now, let's use a dummy value or integrate with MockMoodStore if available
        // Assuming Mood model will also be SwiftData or accessible
        totalMoodCheckIns = MockMoodStore().fetchMoods().count // Using MockMoodStore for now

        // Weekly Mood Graph (Placeholder)
        // In a real app, this would query mood entries for the last 7 days
        weeklyMoodValues = [0.7, 0.8, 0.6, 0.9, 0.7, 0.8, 0.75]
        averageWeeklyMood = weeklyMoodValues.reduce(0, +) / Double(weeklyMoodValues.count)

        // Weekly Journal Frequency Graph (Placeholder)
        // In a real app, this would query journal entries for the last 7 days
        weeklyJournalValues = [1.0, 0.0, 2.0, 1.0, 0.0, 1.0, 1.0]
    }
    
    // Call this when a mood is saved
    func incrementMoodCheckIns() {
        totalMoodCheckIns += 1
        // Also update weeklyMoodValues and averageWeeklyMood if needed
        // For now, just increment total
    }
    
    // Call this when a journal entry is saved
    func incrementJournalEntries() {
        totalJournalEntries += 1
        // Also update weeklyJournalValues if needed
        // For now, just increment total
    }
}
