import SwiftUI

struct GoalProgressEditorView: View {
    @Bindable var goal: Goal
    @Environment(\.dismiss) var dismiss
    
    @State private var currentProgress: Double
    
    init(goal: Goal) {
        _goal = Bindable(wrappedValue: goal)
        _currentProgress = State(initialValue: goal.progress)
    }

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            // Live Preview
            AnimatedProgressRingView(
                progress: currentProgress,
                thickness: 25,
                width: 200,
                gradient: AppColors.gradient(for: AppColors.theme(for: currentProgress))
            )
            .padding()

            // Slider
            ProgressSliderView(progress: $currentProgress, tintColor: AppColors.color(for: AppColors.theme(for: currentProgress)))
                .padding(.horizontal)

            // Action Buttons
            HStack(spacing: AppSpacing.medium) {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(AppButtonStyle(style: .secondary))
                
                Button("Confirm") {
                    goal.progress = currentProgress
                    let haptic = UIImpactFeedbackGenerator(style: .heavy)
                    haptic.impactOccurred()
                    dismiss()
                }
                .buttonStyle(AppButtonStyle(style: .primary(gradient: LinearGradient(gradient: AppColors.gradient(for: AppColors.theme(for: currentProgress)), startPoint: .top, endPoint: .bottom))))
            }
            .padding()
        }
        .padding(.vertical, AppSpacing.large)
        .background(AppColors.background)
    }
}

struct GoalProgressEditorView_Previews: PreviewProvider {
    static var previews: some View {
        let goal = Goal(
            title: "Preview Goal",
            details: "Details here",
            deadline: Date(),
            createdAt: Date(),
            isCompleted: false,
            progress: 0.4,
            category: .health
        )
        
        GoalProgressEditorView(goal: goal)
    }
}