import Foundation

enum GoalCategory: String, Codable, CaseIterable, Identifiable {
    case health = "Health"
    case work = "Work"
    case learning = "Learning"
    case personal = "Personal"
    case other = "Other"

    var id: String { self.rawValue }

    var icon: String {
        switch self {
        case .health: return "heart.fill"
        case .work: return "briefcase.fill"
        case .learning: return "book.closed.fill"
        case .personal: return "person.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
}
