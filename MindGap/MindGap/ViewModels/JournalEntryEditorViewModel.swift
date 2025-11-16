import Foundation
import SwiftData

class JournalEntryEditorViewModel: ObservableObject {
    private var modelContext: ModelContext
    private var entry: JournalEntry?

    @Published var title: String = ""
    @Published var body: String = ""
    @Published var date: Date = Date()
    @Published var moodTag: String? = nil

    init(modelContext: ModelContext, entry: JournalEntry? = nil) {
        self.modelContext = modelContext
        self.entry = entry
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
        }

        do {
            try modelContext.save()
        } catch {
            print("Save failed")
        }
    }
}
