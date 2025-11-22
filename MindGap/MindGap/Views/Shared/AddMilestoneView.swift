import SwiftUI
import SwiftData

struct AddMilestoneView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GoalDetailViewModel
    
    @State private var milestoneTitle: String = ""
    @State private var milestoneDueDate: Date = Date()
    @State private var isDueDateEnabled: Bool = false
    @State private var showingTitleError: Bool = false

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            // Header
            HStack {
                Text("Add New Milestone")
                    .appFont(style: .headline)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            Form {
                Section {
                    TextField("Milestone Title", text: $milestoneTitle)
                        .appFont(style: .body)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppSpacing.medium)
                                .stroke(showingTitleError ? .red : .clear, lineWidth: 2)
                        )
                        .onChange(of: milestoneTitle) { _ in
                            showingTitleError = false
                        }
                    
                    Toggle(isOn: $isDueDateEnabled) {
                        Text("Set Due Date")
                            .appFont(style: .body)
                    }
                    
                    if isDueDateEnabled {
                        DatePicker("Due Date", selection: $milestoneDueDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .appFont(style: .body)
                    }
                }
            }
            // Spacer to push content up
            Spacer()

            // Add Milestone Button
            Button {
                addMilestoneAction()
            } label: {
                Text("Add Milestone")
            }
            .buttonStyle(AppButtonStyle(style: .primary()))
            .padding(.horizontal)
            .padding(.bottom, AppSpacing.large)
        }
        .presentationDetents([.medium, .large])
        .presentationBackground(.ultraThinMaterial)
        .presentationCornerRadius(AppSpacing.large)
    }

    private func addMilestoneAction() {
        if milestoneTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showingTitleError = true
            // Add haptic feedback for error
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            return
        }
        
        let dueDate = isDueDateEnabled ? milestoneDueDate : nil
        viewModel.addMilestone(title: milestoneTitle, dueDate: dueDate)
        dismiss()
    }
}

struct AddMilestoneView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Goal.self, configurations: config)
        let storage = SwiftDataGoalStorage(modelContext: container.mainContext)
        let goal = Goal(title: "Sample Goal", details: "", deadline: Date(), createdAt: Date(), isCompleted: false, progress: 0.5, category: .personal)
        
        @Namespace var namespace // For the ViewModel init
        let viewModel = GoalDetailViewModel(goal: goal, storage: storage, namespace: namespace)
        
        return AddMilestoneView(viewModel: viewModel)
    }
}
