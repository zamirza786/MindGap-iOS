import SwiftUI

struct PriorityToggle: View {
    @Binding var selectedPriority: GoalPriority
    @Namespace private var animation

    var body: some View {
        HStack {
            ForEach(GoalPriority.allCases) { priority in
                Text(priority.rawValue)
                    .appFont(style: .caption)
                    .padding(.vertical, AppSpacing.small)
                    .padding(.horizontal, AppSpacing.medium)
                    .background(
                        ZStack {
                            if selectedPriority == priority {
                                Capsule()
                                    .fill(priority.color)
                                    .matchedGeometryEffect(id: "prioritySelection", in: animation)
                            } else {
                                Capsule()
                                    .fill(AppColors.card)
                                    .stroke(AppColors.textSecondary.opacity(0.2), lineWidth: 1)
                            }
                        }
                    )
                    .foregroundColor(selectedPriority == priority ? AppColors.background : AppColors.text)
                    .onTapGesture {
                        withAnimation(.spring) {
                            selectedPriority = priority
                        }
                    }
            }
        }
    }
}

struct PriorityToggle_Previews: PreviewProvider {
    @State static var priority: GoalPriority = .normal
    static var previews: some View {
        PriorityToggle(selectedPriority: $priority)
            .environmentObject(ThemeManager())
    }
}
