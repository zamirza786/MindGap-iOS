import SwiftUI
import SwiftData

struct GoalDetailView: View {
    @StateObject var viewModel: GoalDetailViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    // Header
                    GoalDetailHeaderView(viewModel: viewModel, namespace: viewModel.namespace)
                        .padding(.horizontal)
                    
                    // Progress Section
                    ProgressSectionView(viewModel: viewModel)
                    
                    // Milestones Section
                    MilestoneSectionView(viewModel: viewModel)
                    
                    // Timeline Section
                    TimelineSectionView(timeline: viewModel.timeline)
                    
                    // Spacer to push content up
                    Spacer(minLength: 80)
                }
                .padding(.vertical)
            }
            .background(AppColors.background)
            .navigationBarHidden(true)
            .onDisappear {
                viewModel.saveChanges()
            }
            
            // Bottom Action Buttons
            HStack(spacing: AppSpacing.medium) {
                DeleteButtonView {
                    showingDeleteConfirmation = true
                }
                EditButtonView {
                    viewModel.openEditGoal()
                }
            }
            .padding()
            .background(.thinMaterial)
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $viewModel.showProgressSheet) {
            GoalProgressEditorView(goal: viewModel.goal)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $viewModel.showEditGoalSheet) {
            // The AddEditGoalView will need to be updated to support the hero animation
            // For now, we present it as a simple sheet
            AddEditGoalView(
                viewModel: AddEditGoalViewModel(mode: .edit(viewModel.goal), storage: viewModel.storage),
                animation: viewModel.namespace
            )
        }
        .alert("Delete Goal", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                viewModel.deleteGoal()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this goal? This action cannot be undone.")
        }
    }
}

struct GoalDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Goal.self, configurations: config)
        let storage = SwiftDataGoalStorage(modelContext: container.mainContext)
        
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
            milestones: [
                Milestone(title: "Read the docs", isCompleted: true),
                Milestone(title: "Build a demo app", isCompleted: false),
            ]
        )
        container.mainContext.insert(goal)
        
        let viewModel = GoalDetailViewModel(goal: goal, storage: storage, namespace: namespace)
        
        return GoalDetailView(viewModel: viewModel)
            .environmentObject(ThemeManager())
    }
}
