import Foundation

/// Represents a single journal entry made by the user.
struct ReflectionEntry: Codable, Identifiable, Hashable {
    let id: UUID
    let date: Date
    let question: String
    let answer: String
    let mood: Mood

    /// A simple enum to represent the user's mood for the day.
    enum Mood: String, Codable, CaseIterable, Identifiable {
        case happy = "Happy"
        case neutral = "Neutral"
        case sad = "Sad"

        var id: String { self.rawValue }

        var emoji: String {
            switch self {
            case .happy:
                return "😊"
            case .neutral:
                return "😐"
            case .sad:
                return "😔"
            }
        }
    }
    
    init(id: UUID = UUID(), date: Date = Date(), question: String, answer: String, mood: Mood) {
        self.id = id
        self.date = date
        self.question = question
        self.answer = answer
        self.mood = mood
    }
}