import Foundation
import SwiftData

class JournalEntryEditorViewModel: ObservableObject {
    private var modelContext: ModelContext
    private var entry: JournalEntry?
    private let streakManager: StreakManager
    private let analyticsManager: AnalyticsManager

    @Published var title: String = ""
    @Published var body: String = ""
    @Published var date: Date = Date()
    @Published var moodTag: String? = nil

    init(modelContext: ModelContext, entry: JournalEntry? = nil, streakManager: StreakManager = .shared, analyticsManager: AnalyticsManager = .shared) {
        self.modelContext = modelContext
        self.entry = entry
        self.streakManager = streakManager
        self.analyticsManager = analyticsManager
        if let entry = entry {
            self.title = entry.title
            self.body = entry.body
            self.date = entry.date
            self.moodTag = entry.moodTag
        }
    }

    func save() {
        if let entry = entry {
            entry.title = title
            entry.body = body
            entry.date = date
            entry.moodTag = moodTag
        } else {
            let newEntry = JournalEntry(title: title, body: body, date: date, moodTag: moodTag)
            modelContext.insert(newEntry)
            streakManager.incrementJournalStreak()
            analyticsManager.incrementJournalEntries()
        }

        do {
            try modelContext.save()
        } catch {
            print("Save failed")
        }
    }
}
