import Foundation

struct Mood: Identifiable {
    let id = UUID()
    let moodType: MoodType
    let intensity: Double
    let note: String?
    let timestamp: Date
}

enum MoodType: String, CaseIterable {
    case happy = "Happy"
    case neutral = "Neutral"
    case sad = "Sad"
    case stressed = "Stressed"
    case anxious = "Anxious"
    case tired = "Tired"

    var icon: String {
        switch self {
        case .happy: return "smiley.fill"
        case .neutral: return "face.smiling"
        case .sad: return "face.dashed"
        case .stressed: return "exclamationmark.triangle.fill"
        case .anxious: return "bolt.fill"
        case .tired: return "moon.zzz.fill"
        }
    }
}
