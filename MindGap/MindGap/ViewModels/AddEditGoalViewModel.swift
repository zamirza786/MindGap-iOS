import Foundation
import SwiftUI
import Combine
import SwiftData

enum GoalMode: Identifiable {
    case add
    case edit(Goal)

    var id: String {
        switch self {
        case .add: return "add"
        case .edit(let goal): return "edit-\(goal.id.uuidString)"
        }
    }

    var title: String {
        switch self {
        case .add: return "Add New Goal"
        case .edit: return "Edit Goal"
        }
    }
}

class AddEditGoalViewModel: ObservableObject {
    private let storage: GoalStorageProtocol
    private var originalGoal: Goal? // Keep a reference to the original goal for editing
    var originalGoalID: String? { originalGoal?.id.uuidString }
    let mode: GoalMode

    // Form fields
    @Published var title: String = ""
    @Published var details: String = ""
    @Published var deadline: Date = Date().addingTimeInterval(86400 * 7) // 7 days from now
    @Published var isCompleted: Bool = false
    @Published var progress: Double = 0.0
    @Published var category: GoalCategory = .personal
    @Published var priority: GoalPriority = .normal
    @Published var icon: String = "star.fill"
    @Published var color: String = "#4285F4" // Hex string

    // UI State
    @Published var showTitleError: Bool = false
    @Published var showSaveSuccess: Bool = false
    @Published var isSaving: Bool = false

    var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var saveButtonText: String {
        isEditing ? "Save Changes" : "Add Goal"
    }

    init(mode: GoalMode, storage: GoalStorageProtocol) {
        self.mode = mode
        self.storage = storage

        if case .edit(let goal) = mode {
            self.originalGoal = goal
            self.title = goal.title
            self.details = goal.details
            self.deadline = goal.deadline
            self.isCompleted = goal.isCompleted
            self.progress = goal.progress
            self.category = goal.category
            self.priority = goal.priority ?? .normal // Handle optional priority
            self.icon = goal.icon
            self.color = goal.color
        }
    }

    func saveGoal() {
        guard isFormValid else {
            showTitleError = true
            return
        }

        isSaving = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Simulate network/disk delay
            if let originalGoal = self.originalGoal {
                // Update existing goal
                originalGoal.title = self.title
                originalGoal.details = self.details
                originalGoal.deadline = self.deadline
                originalGoal.isCompleted = self.isCompleted
                originalGoal.progress = self.progress
                originalGoal.category = self.category
                originalGoal.priority = self.priority
                originalGoal.icon = self.icon
                originalGoal.color = self.color
                self.storage.updateGoal(originalGoal)
            } else {
                // Create new goal
                let newGoal = Goal(
                    title: self.title,
                    details: self.details,
                    deadline: self.deadline,
                    createdAt: Date(),
                    isCompleted: self.isCompleted,
                    progress: self.progress,
                    category: self.category,
                    priority: self.priority,
                    icon: self.icon,
                    color: self.color
                )
                self.storage.addGoal(newGoal)
            }
            self.isSaving = false
            self.showSaveSuccess = true
        }
    }

    func deleteGoal() {
        guard let goalToDelete = originalGoal else { return }
        storage.deleteGoal(goalToDelete)
    }
    
    // Helper to convert hex string to Color
    func uiColor(from hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        return Color(red: red, green: green, blue: blue)
    }
}