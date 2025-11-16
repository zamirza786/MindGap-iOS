import Foundation

protocol MoodDataStore {
    func save(mood: Mood)
    func fetchMoods() -> [Mood]
}

class MockMoodStore: MoodDataStore {
    private var moods: [Mood] = []

    func save(mood: Mood) {
        moods.append(mood)
        print("Mood saved: \(mood)")
    }

    func fetchMoods() -> [Mood] {
        return moods
    }
}
