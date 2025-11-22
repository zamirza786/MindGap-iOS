import SwiftUI

struct GoalDetailHeaderView: View {
    @ObservedObject var viewModel: GoalDetailViewModel
    let namespace: Namespace.ID

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            // MARK: - Icon and Priority
            HStack {
                // Goal Icon
                Image(systemName: viewModel.goal.icon)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color(hex: viewModel.goal.color))
                    .matchedGeometryEffect(id: "goalIcon_\(viewModel.goal.id)", in: namespace)
                
                Spacer()
                
                // Priority Tag
                PriorityTagView(priority: viewModel.goal.priority)
                    .matchedGeometryEffect(id: "goalPriority_\(viewModel.goal.id)", in: namespace)
            }
            
            // MARK: - Title and Details
            Text(viewModel.goal.title)
                .appFont(style: .title1)
                .matchedGeometryEffect(id: "goalTitle_\(viewModel.goal.id)", in: namespace)

            Text(viewModel.goal.details)
                .appFont(style: .body)
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(3)

            // MARK: - Progress
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                AnimatedProgressRingView(
                    progress: viewModel.progress,
                    thickness: 12,
                    width: 100,
                    gradient: AppColors.gradient(for: AppColors.theme(for: viewModel.progress))
                )
                .matchedGeometryEffect(id: "goalProgress_\(viewModel.goal.id)", in: namespace)
                
                Text("Current Progress")
                    .appFont(style: .caption)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.large)
        .background(
            ZStack {
                // Background Card
                AppColors.card
                    .matchedGeometryEffect(id: "goalCard_\(viewModel.goal.id)", in: namespace)
                
                // Color Strip
                Color(hex: viewModel.goal.color)
                    .frame(height: 8)
                    .matchedGeometryEffect(id: "goalColorStrip_\(viewModel.goal.id)", in: namespace)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        )
        .cornerRadius(AppSpacing.large)
        .appShadow(.large)
    }
}

struct GoalDetailHeaderView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        let storage = MockGoalStorage()
        let goal = Goal(
            title: "Master SwiftUI Animations",
            details: "Learn advanced techniques for creating fluid and engaging user interfaces.",
            deadline: Date().addingTimeInterval(86400 * 30),
            createdAt: Date(),
            isCompleted: false,
            progress: 0.65,
            category: .learning,
            priority: .high,
            icon: "sparkles",
            color: "#5E5CE6",
            milestones: []
        )
        let viewModel = GoalDetailViewModel(goal: goal, storage: storage, namespace: namespace)
        
        GoalDetailHeaderView(viewModel: viewModel, namespace: namespace)
            .padding()
            .background(AppColors.background)
    }
}
