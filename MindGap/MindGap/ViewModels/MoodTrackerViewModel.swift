import SwiftUI

class MoodTrackerViewModel: ObservableObject {
    private let dataStore: MoodDataStore
    private let streakManager: StreakManager
    private let analyticsManager: AnalyticsManager

    @Published var selectedMood: MoodType?
    @Published var intensity: Double = 0.5
    @Published var note: String = ""

    init(dataStore: MoodDataStore = MockMoodStore(), streakManager: StreakManager = .shared, analyticsManager: AnalyticsManager = .shared) {
        self.dataStore = dataStore
        self.streakManager = streakManager
        self.analyticsManager = analyticsManager
    }

    func saveMood() {
        guard let selectedMood = selectedMood else { return }
        let mood = Mood(
            moodType: selectedMood,
            intensity: intensity,
            note: note.isEmpty ? nil : note,
            timestamp: Date()
        )
        dataStore.save(mood: mood)
        streakManager.incrementMoodStreak()
        analyticsManager.incrementMoodCheckIns()
    }
}
