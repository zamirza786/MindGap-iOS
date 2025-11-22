import SwiftUI
import SwiftData

struct AddEditGoalView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext // For GoalStorageProtocol
    @StateObject var viewModel: AddEditGoalViewModel
    @FocusState private var isTitleFieldFocused: Bool
    let animation: Namespace.ID // For hero animations

    // State for sheet presentation
    @State private var currentDetent: PresentationDetent = .medium
    @State private var showDeleteConfirmation = false

    var body: some View {
        let currentTheme = AppColors.theme(for: viewModel.progress)
        let dynamicGradient = AppColors.gradient(for: currentTheme)
        let dynamicColor = AppColors.color(for: currentTheme)

        VStack(spacing: 0) { // Use VStack to stack header, form, and sticky button
            // MARK: - Header
            HStack {
                // Hero Animated Icon
                Image(systemName: viewModel.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(viewModel.uiColor(from: viewModel.color))
                    .matchedGeometryEffect(id: "goalIcon_\(viewModel.originalGoalID ?? "new")", in: animation)
                    .padding(.leading, AppSpacing.medium)

                // Dynamic Title
                Text(viewModel.mode.title)
                    .appFont(style: .headline)
                    .matchedGeometryEffect(id: "goalTitle_\(viewModel.originalGoalID ?? "new")", in: animation)
                
                Spacer()

                // Delete Button (Edit mode only)
                if viewModel.isEditing {
                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "trash.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    .padding(.trailing, AppSpacing.small)
                }
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, AppSpacing.medium)
            .background(.ultraThinMaterial) // Blurred background for header
            .animation(.smooth, value: viewModel.icon)
            .animation(.smooth, value: viewModel.color)

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    // MARK: - Form Section 1: Goal Info
                    VStack(alignment: .leading, spacing: AppSpacing.medium) {
                        Text("Goal Info")
                            .appFont(style: .subheadline)
                            .padding(.horizontal)

                        VStack(spacing: AppSpacing.small) {
                            TextField("Goal Title", text: $viewModel.title)
                                .appFont(style: .body)
                                .padding(AppSpacing.medium)
                                .background(AppColors.card)
                                .cornerRadius(AppSpacing.medium)
                                .focused($isTitleFieldFocused)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppSpacing.medium)
                                        .stroke(viewModel.showTitleError ? .red : (isTitleFieldFocused ? dynamicColor : .clear), lineWidth: 2)
                                )
                                .modifier(ShakeEffect(animatableData: viewModel.showTitleError ? 1 : 0))
                                .onChange(of: viewModel.title) { _ in
                                    viewModel.showTitleError = false
                                }
                                .animation(.smooth, value: isTitleFieldFocused)
                                .animation(.smooth, value: viewModel.showTitleError)
                            
                            TextEditor(text: $viewModel.details)
                                .appFont(style: .body)
                                .frame(minHeight: 80, maxHeight: 150) // Expanding TextEditor
                                .padding(AppSpacing.medium)
                                .background(AppColors.card)
                                .cornerRadius(AppSpacing.medium)
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Form Section 2: Settings
                    VStack(alignment: .leading, spacing: AppSpacing.medium) {
                        Text("Settings")
                            .appFont(style: .subheadline)
                            .padding(.horizontal)

                        VStack(spacing: AppSpacing.small) {
                            // Priority Selector
                            PrioritySelectorView(selectedPriority: $viewModel.priority)
                                .padding(AppSpacing.medium)
                                .background(AppColors.card)
                                .cornerRadius(AppSpacing.medium)
                            
                            // Icon Picker
                            IconSelectorView(selectedIcon: $viewModel.icon)
                                .padding(.vertical, AppSpacing.small)
                                .background(AppColors.card)
                                .cornerRadius(AppSpacing.medium)

                            // Color Picker
                            ColorSelectorView(selectedColorHex: $viewModel.color)
                                .padding(.vertical, AppSpacing.small)
                                .background(AppColors.card)
                                .cornerRadius(AppSpacing.medium)

                            // Optional Due Date
                            Toggle(isOn: Binding(
                                get: { viewModel.deadline != Date.distantFuture },
                                set: { isOn in
                                    if isOn {
                                        viewModel.deadline = Date().addingTimeInterval(86400 * 7) // Default to 7 days from now
                                    } else {
                                        viewModel.deadline = Date.distantFuture
                                    }
                                }
                            )) {
                                Text("Set Due Date")
                                    .appFont(style: .body)
                            }
                            .padding(AppSpacing.medium)
                            .background(AppColors.card)
                            .cornerRadius(AppSpacing.medium)

                            if viewModel.deadline != Date.distantFuture {
                                DatePicker("Due Date", selection: $viewModel.deadline, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .appFont(style: .body)
                                    .padding(AppSpacing.medium)
                                    .background(AppColors.card)
                                    .cornerRadius(AppSpacing.medium)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: - Form Section 3: Progress (Edit mode only)
                    if viewModel.isEditing {
                        VStack(alignment: .leading, spacing: AppSpacing.medium) {
                            Text("Progress")
                                .appFont(style: .subheadline)
                                .padding(.horizontal)
                            
                            ProgressSliderView(progress: $viewModel.progress, tintColor: dynamicColor)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 100) // Space for sticky button
            }
            .background(AppColors.background)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear {
                if case .add = viewModel.mode {
                    isTitleFieldFocused = true // Autofocus title field in Add mode
                }
            }

            // MARK: - Sticky Save Button
            AnimatedSaveButton(viewModel: viewModel, saveAction: {
                viewModel.saveGoal()
            })
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: viewModel.isFormValid)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: viewModel.isSaving)
        }
        .presentationDetents([.medium, .large], selection: $currentDetent)
        .interactiveDismissDisabled(false)
        .presentationBackground(.ultraThinMaterial)
        .presentationCornerRadius(AppSpacing.large)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: currentDetent)
        .alert("Delete Goal", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                viewModel.deleteGoal()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this goal?")
        }
        .onChange(of: viewModel.showSaveSuccess) { success in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Allow success animation to play
                    dismiss()
                }
            }
        }
    }
}

// MARK: - ShakeEffect (Moved here for self-containment)
struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 10
    var numberOfShakes: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: travelDistance * sin(animatableData * .pi * numberOfShakes), y: 0))
    }
}

struct AddEditGoalView_Previews: PreviewProvider {
    @Namespace static var previewAnimation
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Goal.self, configurations: config)
        
        let mockStorage = SwiftDataGoalStorage(modelContext: container.mainContext)
        let sampleGoal = Goal(title: "Learn SwiftUI", details: "Complete a SwiftUI course and build a small app.", deadline: Calendar.current.date(byAdding: .day, value: 10, to: Date())!, createdAt: Date(), isCompleted: false, progress: 0.7, category: .learning, priority: .high, icon: "book.closed.fill", color: "#0F9D58")
        container.mainContext.insert(sampleGoal)

        return Group {
            AddEditGoalView(viewModel: AddEditGoalViewModel(mode: .add, storage: mockStorage), animation: previewAnimation)
                .previewDisplayName("Add New Goal")
            AddEditGoalView(viewModel: AddEditGoalViewModel(mode: .edit(sampleGoal), storage: mockStorage), animation: previewAnimation)
                .previewDisplayName("Edit Existing Goal")
        }
        .environmentObject(ThemeManager())
        .modelContainer(container)
    }
}