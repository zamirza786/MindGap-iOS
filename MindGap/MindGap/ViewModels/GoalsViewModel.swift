import Foundation
import Combine
import SwiftData

enum GoalFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case upcoming = "Upcoming"
    case completed = "Completed"
    case health = "Health"
    case work = "Work"
    case learning = "Learning"
    case personal = "Personal"
    case other = "Other"

    var id: String { self.rawValue }
}

class GoalsViewModel: ObservableObject {
    let storage: GoalStorageProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var allGoals: [Goal] = []
    @Published var selectedFilter: GoalFilter = .all

    init(storage: GoalStorageProtocol) {
        self.storage = storage
        
        // Since GoalStore is now ObservableObject and conforms to GoalStorageProtocol,
        // we can still observe its @Published goals if the storage is a GoalStore.
        if let goalStore = storage as? GoalStore {
            goalStore.$goals
                .assign(to: &$allGoals)
        } else {
            // Fallback for other storage types, fetch once
            allGoals = storage.fetchGoals()
        }
        // Ensure initial fetch always happens
        refreshGoals()
    }

    var filteredGoals: [Goal] {
        switch selectedFilter {
        case .all:
            return allGoals
        case .upcoming:
            return allGoals.filter { !$0.isCompleted && $0.deadline > Date() }
        case .completed:
            return allGoals.filter { $0.isCompleted }
        case .health:
            return allGoals.filter { $0.category == .health }
        case .work:
            return allGoals.filter { $0.category == .work }
        case .learning:
            return allGoals.filter { $0.category == .learning }
        case .personal:
            return allGoals.filter { $0.category == .personal }
        case .other:
            return allGoals.filter { $0.category == .other }
        }
    }
    
    var overallProgress: Double {
        guard !allGoals.isEmpty else { return 0.0 }
        let completedCount = allGoals.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(allGoals.count)
    }

    func refreshGoals() {
        allGoals = storage.fetchGoals()
    }

    func deleteGoal(at offsets: IndexSet) {
        for index in offsets {
            let goal = filteredGoals[index] // Delete from filtered list
            storage.deleteGoal(goal)
        }
        refreshGoals() // Refresh after deletion
    }
    
    func toggleCompletion(for goal: Goal) {
        goal.isCompleted.toggle()
        storage.updateGoal(goal)
        refreshGoals() // Refresh after update
    }
}
