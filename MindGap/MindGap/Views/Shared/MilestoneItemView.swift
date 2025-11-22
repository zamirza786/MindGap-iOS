import SwiftUI

struct MilestoneItemView: View {
    let milestone: Milestone
    let onToggle: () -> Void
    
    @State private var isCompleted: Bool
    @State private var scale: CGFloat = 1.0

    init(milestone: Milestone, onToggle: @escaping () -> Void) {
        self.milestone = milestone
        self.onToggle = onToggle
        _isCompleted = State(initialValue: milestone.isCompleted)
    }

    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            // Animated Checkbox
            ZStack {
                Circle()
                    .stroke(isCompleted ? AppColors.accent : AppColors.textSecondary, lineWidth: 2)
                    .frame(width: 28, height: 28)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppColors.background)
                        .background(
                            Circle()
                                .fill(AppColors.accent)
                                .frame(width: 28, height: 28)
                        )
                        .scaleEffect(scale)
                }
            }
            .onTapGesture {
                toggleCompletion()
            }
            
            // Milestone Title
            Text(milestone.title)
                .appFont(style: .body)
                .strikethrough(isCompleted, color: AppColors.textSecondary)
                .foregroundColor(isCompleted ? AppColors.textSecondary : AppColors.text)
            
            Spacer()
        }
        .padding(AppSpacing.medium)
        .background(AppColors.card)
        .cornerRadius(AppSpacing.medium)
        .onChange(of: milestone.isCompleted) { newValue in
            // This ensures the view updates if the underlying model changes from elsewhere
            if isCompleted != newValue {
                 withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isCompleted = newValue
                    scale = newValue ? 1.2 : 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        scale = 1.0
                    }
                }
            }
        }
    }

    private func toggleCompletion() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            isCompleted.toggle()
            scale = isCompleted ? 1.2 : 1.0
        }
        
        // Use a slight delay for the haptic feedback and the callback
        // to make the animation feel more responsive.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                scale = 1.0
            }
            // Trigger haptic feedback
            let haptic = UIImpactFeedbackGenerator(style: .medium)
            haptic.impactOccurred()
            
            onToggle()
        }
    }
}

struct MilestoneItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            MilestoneItemView(
                milestone: Milestone(title: "Design the main screen", isCompleted: false),
                onToggle: { print("Toggled first") }
            )
            
            MilestoneItemView(
                milestone: Milestone(title: "Implement the networking layer", isCompleted: true),
                onToggle: { print("Toggled second") }
            )
            
            MilestoneItemView(
                milestone: Milestone(title: "Write unit tests for the view model and make this a very long line to check wrapping", isCompleted: false),
                onToggle: { print("Toggled third") }
            )
        }
        .padding()
        .background(AppColors.background)
    }
}
