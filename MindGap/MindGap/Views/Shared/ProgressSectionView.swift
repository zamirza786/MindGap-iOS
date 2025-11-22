import SwiftUI

struct ProgressSectionView: View {
    @ObservedObject var viewModel: GoalDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Progress")
                .appFont(style: .headline)

            Button(action: {
                viewModel.showProgressSheet = true
            }) {
                HStack {
                    Text("Update Progress")
                    Spacer()
                    Image(systemName: "pencil.circle.fill")
                }
            }
            .buttonStyle(AppButtonStyle(style: .secondary))
        }
        .padding(.horizontal)
    }
}

struct ProgressSectionView_Previews: PreviewProvider {
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
            milestones: []
        )
        let viewModel = GoalDetailViewModel(goal: goal, storage: storage, namespace: namespace)

        ProgressSectionView(viewModel: viewModel)
            .padding()
            .background(AppColors.background)
    }
}
