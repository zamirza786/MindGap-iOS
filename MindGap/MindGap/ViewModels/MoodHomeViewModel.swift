import Foundation

class MoodHomeViewModel: ObservableObject {
    @Published var recentMoods: [Mood] = [
        Mood(moodType: .happy, intensity: 0.8, note: "Had a great day with friends.", timestamp: Date().addingTimeInterval(-86400)),
        Mood(moodType: .stressed, intensity: 0.6, note: "Work was a bit overwhelming.", timestamp: Date().addingTimeInterval(-172800)),
        Mood(moodType: .tired, intensity: 0.9, note: "Didn't sleep well last night.", timestamp: Date().addingTimeInterval(-259200))
    ]
}
