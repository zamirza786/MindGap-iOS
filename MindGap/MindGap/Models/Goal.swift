import Foundation
import SwiftUI
import SwiftData

// MARK: - Milestone Model
struct Milestone: Codable, Identifiable, Hashable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date? = nil // New property
}


enum GoalPriority: String, Codable, CaseIterable, Identifiable {
    case low = "Low"
    case normal = "Normal"
    case high = "High"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .normal: return .orange
        case .high: return .red
        }
    }
}

@Model
final class Goal {
    @Attribute(.unique) var id: UUID
    var title: String
    var details: String
    var deadline: Date
    var createdAt: Date
    var isCompleted: Bool
    var progress: Double // 0.0 to 1.0
    var category: GoalCategory
    var priority: GoalPriority?
    var icon: String
    var color: String
    var milestones: [Milestone]

    init(id: UUID = UUID(), 
         title: String,
         details: String,
         deadline: Date,
         createdAt: Date,
         isCompleted: Bool,
         progress: Double,
         category: GoalCategory,
         priority: GoalPriority? = .normal,
         icon: String = "star.fill",
         color: String = "#4285F4",
         milestones: [Milestone] = []) {
        self.id = id
        self.title = title
        self.details = details
        self.deadline = deadline
        self.createdAt = createdAt
        self.isCompleted = isCompleted
        self.progress = progress
        self.category = category
        self.priority = priority
        self.icon = icon
        self.color = color
        self.milestones = milestones
    }
}
