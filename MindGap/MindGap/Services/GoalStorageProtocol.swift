import Foundation
import SwiftData

// MARK: - GoalStorageProtocol
protocol GoalStorageProtocol {
    func addGoal(_ goal: Goal)
    func updateGoal(_ goal: Goal)
    func deleteGoal(_ goal: Goal)
    func fetchGoals() -> [Goal]
}

// MARK: - SwiftDataGoalStorage (Concrete Implementation)
class SwiftDataGoalStorage: GoalStorageProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addGoal(_ goal: Goal) {
        modelContext.insert(goal)
        try? modelContext.save()
    }

    func updateGoal(_ goal: Goal) {
        // SwiftData automatically tracks changes to @Model objects,
        // so simply ensuring it's in the context and saving is enough.
        // If the goal was detached, you might need to re-fetch or insert.
        if goal.modelContext == nil {
            modelContext.insert(goal)
        }
        try? modelContext.save()
    }

    func deleteGoal(_ goal: Goal) {
        modelContext.delete(goal)
        try? modelContext.save()
    }

    func fetchGoals() -> [Goal] {
        do {
            let descriptor = FetchDescriptor<Goal>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch goals: \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: - MockGoalStorage (In-memory for Previews/Testing)
class MockGoalStorage: GoalStorageProtocol {
    private var goals: [Goal] = []

    init(initialGoals: [Goal] = []) {
        self.goals = initialGoals
    }

    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }

    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        }
    }

    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
    }

    func fetchGoals() -> [Goal] {
        return goals
    }
}
