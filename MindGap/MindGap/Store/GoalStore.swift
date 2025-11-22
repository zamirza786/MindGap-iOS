import Foundation
import SwiftData
import Combine

class GoalStore: ObservableObject, GoalStorageProtocol {
    var modelContext: ModelContext

    @Published var goals: [Goal] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchGoals()
    }

    @discardableResult
    func fetchGoals() -> [Goal] {
        do {
            let descriptor = FetchDescriptor<Goal>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
            goals = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch goals: \(error)")
            goals = []
        }
        return goals
    }

    func addGoal(_ goal: Goal) {
        modelContext.insert(goal)
        saveContext()
    }

    func updateGoal(_ goal: Goal) {
        // SwiftData automatically tracks changes to @Model objects,
        // so just ensuring it's in the context and saving is enough.
        saveContext()
    }

    func deleteGoal(_ goal: Goal) {
        modelContext.delete(goal)
        saveContext()
    }
    
    func toggleCompletion(for goal: Goal) {
        goal.isCompleted.toggle()
        if goal.isCompleted {
            goal.progress = 1.0 // Mark as fully complete
        }
        saveContext()
    }
    
    func updateProgress(for goal: Goal, newProgress: Double) {
        goal.progress = max(0.0, min(1.0, newProgress)) // Clamp between 0 and 1
        if goal.progress == 1.0 {
            goal.isCompleted = true
        } else {
            goal.isCompleted = false
        }
        saveContext()
    }

    private func saveContext() {
        do {
            try modelContext.save()
            fetchGoals() // Re-fetch to update published goals
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    // MARK: - Mock Data for Previews
    static func mock(modelContext: ModelContext) -> GoalStore {
        let store = GoalStore(modelContext: modelContext)
        
        let goal1 = Goal(title: "Learn SwiftUI", details: "Complete a SwiftUI course and build a small app.", deadline: Calendar.current.date(byAdding: .day, value: 10, to: Date())!, createdAt: Date(), isCompleted: false, progress: 0.7, category: .learning, icon: "book.closed.fill", color: "#0F9D58")
        let goal2 = Goal(title: "Run 5K", details: "Train for and complete a 5K race.", deadline: Calendar.current.date(byAdding: .day, value: 30, to: Date())!, createdAt: Date().addingTimeInterval(-86400), isCompleted: false, progress: 0.3, category: .health, icon: "figure.run", color: "#4285F4")
        let goal3 = Goal(title: "Read 1 Book", details: "Finish reading 'The Alchemist'.", deadline: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, createdAt: Date().addingTimeInterval(-172800), isCompleted: true, progress: 1.0, category: .personal, icon: "book.fill", color: "#673AB7")
        let goal4 = Goal(title: "Organize Workspace", details: "Declutter and set up a more efficient home office.", deadline: Calendar.current.date(byAdding: .day, value: 7, to: Date())!, createdAt: Date().addingTimeInterval(-259200), isCompleted: false, progress: 0.0, category: .work, icon: "briefcase.fill", color: "#F4B400")
        
        modelContext.insert(goal1)
        modelContext.insert(goal2)
        modelContext.insert(goal3)
        modelContext.insert(goal4)
        
        try? modelContext.save()
        store.fetchGoals()
        return store
    }
}
