import SwiftUI

struct PrioritySelectorView: View {
    @Binding var selectedPriority: GoalPriority

    var body: some View {
        HStack(spacing: AppSpacing.small) {
            ForEach(GoalPriority.allCases) { priority in
                Text(priority.rawValue)
                    .appFont(style: .body)
                    .padding(.vertical, AppSpacing.small)
                    .padding(.horizontal, AppSpacing.medium)
                    .background(
                        Capsule()
                            .fill(selectedPriority == priority ? priority.color.opacity(0.2) : AppColors.card)
                            .overlay(
                                Capsule()
                                    .stroke(selectedPriority == priority ? priority.color : AppColors.textSecondary.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .foregroundColor(selectedPriority == priority ? priority.color : AppColors.text)
                    .onTapGesture {
                        withAnimation(.spring) {
                            selectedPriority = priority
                        }
                    }
            }
        }
    }
}

struct PrioritySelectorView_Previews: PreviewProvider {
    @State static var priority: GoalPriority = .normal
    static var previews: some View {
        PrioritySelectorView(selectedPriority: $priority)
            .environmentObject(ThemeManager())
    }
}
