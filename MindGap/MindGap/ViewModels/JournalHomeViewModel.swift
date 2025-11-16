import Foundation
import SwiftData

class JournalHomeViewModel: ObservableObject {
    var modelContext: ModelContext // Changed to var
    @Published var entries: [JournalEntry] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchEntries()
    }

    func fetchEntries() {
        do {
            let descriptor = FetchDescriptor<JournalEntry>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            entries = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }

    func deleteEntry(at offsets: IndexSet) {
        for offset in offsets {
            let entry = entries[offset]
            modelContext.delete(entry)
        }
        do {
            try modelContext.save()
            fetchEntries()
        } catch {
            print("Delete failed")
        }
    }
}
