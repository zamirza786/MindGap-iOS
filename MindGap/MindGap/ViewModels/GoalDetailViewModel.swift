import SwiftUI
import Combine

// Represents a single event in the goal's history
struct TimelineEvent: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let description: String
    let icon: String // SF Symbol for the event
}

@MainActor
class GoalDetailViewModel: ObservableObject {
    
    @Published var goal: Goal
    
    // UI State
    @Published var progress: Double
    @Published var milestones: [Milestone]
    @Published var timeline: [TimelineEvent] = []
    @Published var showProgressSheet: Bool = false
    @Published var showEditGoalSheet: Bool = false

    // Dependencies
    let storage: GoalStorageProtocol
    
    // Animation
    var namespace: Namespace.ID

    private var cancellables = Set<AnyCancellable>()

    init(goal: Goal, storage: GoalStorageProtocol, namespace: Namespace.ID) {
        self.goal = goal
        self.storage = storage
        self.namespace = namespace
        
        // Initialize published properties from the goal
        self.progress = goal.progress
        self.milestones = goal.milestones
        
        // Generate initial timeline
        generateTimeline()
        
        // Setup subscribers to keep the goal object in sync
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        // When local progress changes, update the goal's progress
        $progress
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] newProgress in
                self?.goal.progress = newProgress
                self?.checkCompletionStatus()
            }
            .store(in: &cancellables)
        
        // When local milestones change, update the goal's milestones
        $milestones
            .sink { [weak self] newMilestones in
                self?.goal.milestones = newMilestones
            }
            .store(in: &cancellables)
    }

    // MARK: - Intents / User Actions

    func updateProgress(_ value: Double) {
        progress = value
        // The subscriber will handle updating the goal and checking completion
    }
    
    func toggleMilestone(id: UUID) {
        guard let index = milestones.firstIndex(where: { $0.id == id }) else { return }
        
        milestones[index].isCompleted.toggle()
        
        // Recalculate goal progress based on milestone completion
        let completedCount = milestones.filter(\.isCompleted).count
        let totalCount = milestones.count
        let newProgress = totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0
        
        updateProgress(newProgress)
    }

    func deleteGoal() {
        storage.deleteGoal(goal)
    }

    func openEditGoal() {
        showEditGoalSheet = true
    }
    
    func saveChanges() {
        storage.updateGoal(goal)
    }

    // MARK: - UI Logic

    func generateTimeline() {
        // In a real app, this would be generated from historical data.
        // For now, we'll create placeholder data.
        var events: [TimelineEvent] = []
        
        events.append(TimelineEvent(date: goal.createdAt, description: "Goal Created", icon: "flag.fill"))
        
        // Add milestone completion events
        for milestone in milestones where milestone.isCompleted {
            // Placeholder: Use a date slightly after creation for demo
            let completedDate = goal.createdAt.addingTimeInterval(86400 * Double.random(in: 1...3))
            events.append(TimelineEvent(date: completedDate, description: "Milestone Completed: \(milestone.title)", icon: "checkmark.circle.fill"))
        }
        
        // Add a placeholder for progress updates
        if goal.progress > 0 && goal.progress < 1 {
            let updateDate = goal.createdAt.addingTimeInterval(86400 * Double.random(in: 4...6))
            events.append(TimelineEvent(date: updateDate, description: "Progress updated to \(Int(goal.progress * 100))%", icon: "chart.bar.fill"))
        }
        
        if goal.isCompleted {
            let completionDate = goal.deadline.addingTimeInterval(-86400) // A day before the deadline
            events.append(TimelineEvent(date: completionDate, description: "Goal Completed!", icon: "star.fill"))
        }
        
        // Sort events by date
        self.timeline = events.sorted(by: { $0.date < $1.date })
    }
    
    var priorityText: String {
        goal.priority?.rawValue ?? "Normal"
    }
    
    var createdDateText: String {
        "Created on \(goal.createdAt.formatted(date: .abbreviated, time: .omitted))"
    }
    
    var dueDateText: String? {
        guard goal.deadline != Date.distantFuture else { return nil }
        return "Due by \(goal.deadline.formatted(date: .abbreviated, time: .omitted))"
    }

    private func checkCompletionStatus() {
        if progress >= 1.0 {
            goal.isCompleted = true
        } else {
            goal.isCompleted = false
        }
    }
}
