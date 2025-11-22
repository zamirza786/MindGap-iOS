import SwiftUI
import SwiftData

struct GoalRowView: View {
    @Bindable var goal: Goal
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    let animation: Namespace.ID // Add animation namespace

    var body: some View {
        let currentTheme = AppColors.theme(for: goal.progress)

        HStack(spacing: AppSpacing.medium) {
            // Checkmark Toggle
            Button {
                goalsViewModel.toggleCompletion(for: goal)
            } label: {
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(goal.isCompleted ? AppColors.color(for: currentTheme) : AppColors.textSecondary) // Dynamic color
            }
            .buttonStyle(.plain)

            // Category Icon
            GoalCategoryIconView(category: goal.category)
                .foregroundColor(AppColors.color(for: currentTheme)) // Dynamic color
                .matchedGeometryEffect(id: "goalIcon_\(goal.id)", in: animation)

            VStack(alignment: .leading) {
                Text(goal.title)
                    .appFont(style: .body)
                    .strikethrough(goal.isCompleted, pattern: .solid, color: AppColors.textSecondary)
                    .foregroundColor(goal.isCompleted ? AppColors.textSecondary : AppColors.text)
                    .matchedGeometryEffect(id: "goalTitle_\(goal.id)", in: animation)
                
                Text(deadlineText)
                    .appFont(style: .caption)
                    .foregroundColor(deadlineColor)
            }
            
            Spacer()
            
            // Progress Ring
            ProgressRingView(progress: goal.progress, thickness: 8, width: 40) // Adjust size for row
                .matchedGeometryEffect(id: "goalProgress_\(goal.id)", in: animation)
        }
        .padding()
        .background(
            ZStack(alignment: .leading) {
                AppColors.card // Base card background
                RoundedRectangle(cornerRadius: AppSpacing.small) // Accent line
                    .fill(AppColors.gradient(for: currentTheme))
                    .frame(width: 5)
                    .matchedGeometryEffect(id: "goalColorStrip_\(goal.id)", in: animation) // Match the color bar
            }
        )
        .cornerRadius(AppSpacing.medium)
        .appShadow(.small)
        .matchedGeometryEffect(id: "goalCard_\(goal.id)", in: animation) // Match the whole card
    }
    
    private var deadlineText: String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: goal.deadline)
        
        if goal.isCompleted {
            return "Completed"
        } else if let days = components.day, days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") left"
        } else if let days = components.day, days == 0 {
            return "Due today"
        } else {
            return "Overdue"
        }
    }
    
    private var deadlineColor: Color {
        if goal.isCompleted {
            return AppColors.textSecondary
        }
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: goal.deadline)
        
        if let days = components.day, days <= 1 {
            return .red // Urgent
        } else if let days = components.day, days <= 3 {
            return .orange // Soon
        } else {
            return AppColors.textSecondary
        }
    }
}

struct GoalRowView_Previews: PreviewProvider {
    @Namespace static var previewAnimation
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Goal.self, configurations: config)
        
        let goal1 = Goal(title: "Learn SwiftUI", details: "Complete a SwiftUI course and build a small app.", deadline: Calendar.current.date(byAdding: .day, value: 10, to: Date())!, createdAt: Date(), isCompleted: false, progress: 0.7, category: .learning, icon: "book.closed.fill", color: "#0F9D58")
        let goal2 = Goal(title: "Run 5K", details: "Train for and complete a 5K race.", deadline: Calendar.current.date(byAdding: .day, value: 30, to: Date())!, createdAt: Date().addingTimeInterval(-86400), isCompleted: false, progress: 0.3, category: .health, icon: "figure.run", color: "#4285F4")
        let goal3 = Goal(title: "Read 1 Book", details: "Finish reading 'The Alchemist'.", deadline: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, createdAt: Date().addingTimeInterval(-172800), isCompleted: true, progress: 1.0, category: .personal, icon: "book.fill", color: "#673AB7")
        
        container.mainContext.insert(goal1)
        container.mainContext.insert(goal2)
        container.mainContext.insert(goal3)

        return VStack {
            GoalRowView(goal: goal1, animation: previewAnimation)
            GoalRowView(goal: goal2, animation: previewAnimation)
            GoalRowView(goal: goal3, animation: previewAnimation)
        }
        .environmentObject(GoalsViewModel(storage: GoalStore.mock(modelContext: container.mainContext)))
        .environmentObject(ThemeManager())
        .padding()
    }
}
