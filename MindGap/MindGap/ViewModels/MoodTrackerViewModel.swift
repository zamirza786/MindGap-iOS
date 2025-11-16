import SwiftUI

class MoodTrackerViewModel: ObservableObject {
    private let dataStore: MoodDataStore

    @Published var selectedMood: MoodType?
    @Published var intensity: Double = 0.5
    @Published var note: String = ""

    init(dataStore: MoodDataStore = MockMoodStore()) {
        self.dataStore = dataStore
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
    }
}
