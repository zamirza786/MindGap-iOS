import Foundation
import SwiftData

@Model
final class JournalEntry {
    @Attribute(.unique) var id: UUID
    var title: String
    var body: String
    var date: Date
    var moodTag: String?

    init(id: UUID = UUID(), title: String, body: String, date: Date, moodTag: String? = nil) {
        self.id = id
        self.title = title
        self.body = body
        self.date = date
        self.moodTag = moodTag
    }
}
