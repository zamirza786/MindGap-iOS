import SwiftUI

struct MilestoneSectionView: View {
    @ObservedObject var viewModel: GoalDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Milestones")
                .appFont(style: .headline)
                .padding(.horizontal)

            if viewModel.milestones.isEmpty {
                Text("No milestones for this goal yet.")
                    .appFont(style: .body)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal)
            } else {
                ForEach(viewModel.milestones) { milestone in
                    MilestoneItemView(milestone: milestone) {
                        viewModel.toggleMilestone(id: milestone.id)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct MilestoneSectionView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        let storage = MockGoalStorage()
        let goal = Goal(
            title: "Preview Goal",
            details: "...",
            deadline: Date(),
            createdAt: Date(),
            isCompleted: false,
            progress: 0.5,
            category: .work,
            milestones: [
                Milestone(title: "First step", isCompleted: true),
                Milestone(title: "Second step", isCompleted: false)
            ]
        )
        let viewModel = GoalDetailViewModel(goal: goal, storage: storage, namespace: namespace)

        MilestoneSectionView(viewModel: viewModel)
            .padding()
            .background(AppColors.background)
    }
}
