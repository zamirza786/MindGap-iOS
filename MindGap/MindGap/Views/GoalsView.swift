import SwiftUI
import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var goalStore: GoalStore
    @StateObject var viewModel: GoalsViewModel
    @State private var showingAddEditGoalSheet = false
    @State private var showingAddGoalSheet = false
    @Namespace private var goalAnimation // Declare Namespace for hero animations

    // Public initializer for the app to provide a persistent ModelContext
    init(modelContext: ModelContext) {
        let initialGoalStore = GoalStore(modelContext: modelContext)
        _goalStore = StateObject(wrappedValue: initialGoalStore)
        _viewModel = StateObject(wrappedValue: GoalsViewModel(storage: initialGoalStore))
    }

    // Default initializer for previews or when no modelContext is explicitly provided (will use in-memory for previews)
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Goal.self, configurations: config)
        let tempModelContext = ModelContext(container) // In-memory for previews
        
        let initialGoalStore = GoalStore(modelContext: tempModelContext)
        _goalStore = StateObject(wrappedValue: initialGoalStore)
        _viewModel = StateObject(wrappedValue: GoalsViewModel(storage: initialGoalStore))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: AppSpacing.medium) {
                        // Custom Header
                        Text("Your Goals")
                            .appFont(style: .headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, AppSpacing.medium) // Adjust top padding

                        // Overall Progress
                        ProgressRingView(progress: viewModel.overallProgress, thickness: 12, width: 150)
                            .padding(.bottom, AppSpacing.medium)
                            .frame(maxWidth: .infinity, alignment: .center) // Center the ring

                        // Category Filter Chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.small) {
                                ForEach(GoalFilter.allCases) { filter in
                                    GoalFilterChip(filter: filter, isSelected: viewModel.selectedFilter == filter) {
                                        viewModel.selectedFilter = filter
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // List of Goals
                        if viewModel.filteredGoals.isEmpty {
                            EmptyStateView(
                                systemImage: "checklist",
                                title: "No Goals Yet",
                                message: "Start by adding your first goal to track your progress."
                            ) {
                                showingAddGoalSheet = true
                            }
                            .padding()
                            .opacity(0) // Start invisible for fade-in
                            .animation(.easeIn(duration: 0.5), value: viewModel.filteredGoals.isEmpty)
                            .onAppear {
                                // Trigger animation on appear
                            }
                        } else {
                            LazyVStack(spacing: AppSpacing.medium) {
                                ForEach(viewModel.filteredGoals) { goal in
                                    NavigationLink(destination: GoalDetailView(viewModel: GoalDetailViewModel(goal: goal, storage: viewModel.storage, namespace: goalAnimation))) {
                                        GoalRowView(goal: goal, animation: goalAnimation)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .onDelete(perform: viewModel.deleteGoal)
                            }
                            .padding(.horizontal)
                            .environmentObject(viewModel) // Provide GoalsViewModel to GoalRowView
                        }
                    }
                    .padding(.vertical, AppSpacing.medium) // Adjust overall vertical padding
                }
                .background(AppColors.background)
                .ignoresSafeArea(.keyboard, edges: .bottom) // Only ignore keyboard safe area

                // Floating Action Button
                Button {
                    showingAddGoalSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.background)
                        .padding(AppSpacing.medium)
                        .background(AppColors.defaultGradient) // Use default gradient
                        .clipShape(Circle())
                        .appShadow(.medium)
                }
                .padding(AppSpacing.large)
            }
            .navigationTitle("") // Hide default navigation title
            .navigationBarHidden(true) // Hide navigation bar to use custom header
            .onAppear {
                viewModel.refreshGoals() // Ensure goals are fetched when view appears and refreshed on reappear
            }
            .sheet(isPresented: $showingAddGoalSheet) {
                AddEditGoalView(viewModel: AddEditGoalViewModel(mode: .add, storage: SwiftDataGoalStorage(modelContext: modelContext)), animation: goalAnimation)
                    .onDisappear {
                        viewModel.refreshGoals() // Refresh when sheet is dismissed
                    }
            }
        }
    }
}

// MARK: - GoalFilterChip
struct GoalFilterChip: View {
    let filter: GoalFilter
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(filter.rawValue)
                .appFont(style: .caption)
                .foregroundColor(isSelected ? AppColors.background : AppColors.text)
                .padding(.vertical, AppSpacing.small)
                .padding(.horizontal, AppSpacing.medium)
                .background(
                    Group {
                        if isSelected {
                            AppColors.defaultGradient // Use default gradient
                        } else {
                            Capsule()
                                .fill(AppColors.card)
                                .stroke(AppColors.textSecondary.opacity(0.2), lineWidth: 1)
                        }
                    }
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Goal.self, configurations: config)
        
        let goal1 = Goal(title: "Learn SwiftUI", details: "Complete a SwiftUI course and build a small app.", deadline: Calendar.current.date(byAdding: .day, value: 10, to: Date())!, createdAt: Date(), isCompleted: false, progress: 0.7, category: .learning, icon: "book.closed.fill", color: "#0F9D58")
        let goal2 = Goal(title: "Run 5K", details: "Train for and complete a 5K race.", deadline: Calendar.current.date(byAdding: .day, value: 30, to: Date())!, createdAt: Date().addingTimeInterval(-86400), isCompleted: false, progress: 0.3, category: .health, icon: "figure.run", color: "#4285F4")
        container.mainContext.insert(goal1)
        container.mainContext.insert(goal2)

        return GoalsView()
            .environmentObject(ThemeManager())
            .modelContainer(container)
    }
}