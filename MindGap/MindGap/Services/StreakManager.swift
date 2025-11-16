import Foundation
import SwiftUI

class StreakManager: ObservableObject {
    static let shared = StreakManager()

    @AppStorage("lastMoodCheckInDate") private var lastMoodCheckInDateData: Data?
    @Published var currentMoodStreak: Int = 0 {
        didSet {
            UserDefaults.standard.set(currentMoodStreak, forKey: "currentMoodStreak")
        }
    }
    @Published var longestMoodStreak: Int = 0 {
        didSet {
            UserDefaults.standard.set(longestMoodStreak, forKey: "longestMoodStreak")
        }
    }

    @AppStorage("lastJournalEntryDate") private var lastJournalEntryDateData: Data?
    @Published var currentJournalStreak: Int = 0 {
        didSet {
            UserDefaults.standard.set(currentJournalStreak, forKey: "currentJournalStreak")
        }
    }
    @Published var longestJournalStreak: Int = 0 {
        didSet {
            UserDefaults.standard.set(longestJournalStreak, forKey: "longestJournalStreak")
        }
    }

    private init() {
        // On initialization, check if streaks need to be reset
        resetStreakIfMissed()
    }

    private var lastMoodCheckInDate: Date? {
        get {
            guard let data = lastMoodCheckInDateData else { return nil }
            return try? JSONDecoder().decode(Date.self, from: data)
        }
        set {
            lastMoodCheckInDateData = try? JSONEncoder().encode(newValue)
        }
    }

    private var lastJournalEntryDate: Date? {
        get {
            guard let data = lastJournalEntryDateData else { return nil }
            return try? JSONDecoder().decode(Date.self, from: data)
        }
        set {
            lastJournalEntryDateData = try? JSONEncoder().encode(newValue)
        }
    }

    func incrementMoodStreak() {
        let today = Calendar.current.startOfDay(for: Date())

        if let lastDate = lastMoodCheckInDate {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            if Calendar.current.isDate(lastDate, inSameDayAs: today) {
                // Already checked in today, do nothing
                return
            } else if Calendar.current.isDate(lastDate, inSameDayAs: yesterday) {
                currentMoodStreak += 1
            } else {
                currentMoodStreak = 1 // Missed a day, reset
            }
        } else {
            currentMoodStreak = 1 // First check-in
        }
        lastMoodCheckInDate = today
        if currentMoodStreak > longestMoodStreak {
            longestMoodStreak = currentMoodStreak
        }
    }

    func incrementJournalStreak() {
        let today = Calendar.current.startOfDay(for: Date())

        if let lastDate = lastJournalEntryDate {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            if Calendar.current.isDate(lastDate, inSameDayAs: today) {
                // Already entered today, do nothing
                return
            } else if Calendar.current.isDate(lastDate, inSameDayAs: yesterday) {
                currentJournalStreak += 1
            } else {
                currentJournalStreak = 1 // Missed a day, reset
            }
        } else {
            currentJournalStreak = 1 // First entry
        }
        lastJournalEntryDate = today
        if currentJournalStreak > longestJournalStreak {
            longestJournalStreak = currentJournalStreak
        }
    }

    func resetStreakIfMissed() {
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

        // Mood Streak
        if let lastDate = lastMoodCheckInDate, !Calendar.current.isDate(lastDate, inSameDayAs: today) && !Calendar.current.isDate(lastDate, inSameDayAs: yesterday) {
            currentMoodStreak = 0
        } else if lastMoodCheckInDate == nil {
            currentMoodStreak = 0
        }

        // Journal Streak
        if let lastDate = lastJournalEntryDate, !Calendar.current.isDate(lastDate, inSameDayAs: today) && !Calendar.current.isDate(lastDate, inSameDayAs: yesterday) {
            currentJournalStreak = 0
        } else if lastJournalEntryDate == nil {
            currentJournalStreak = 0
        }
    }
}
