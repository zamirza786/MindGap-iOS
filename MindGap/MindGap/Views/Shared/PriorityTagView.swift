import SwiftUI

struct PriorityTagView: View {
    let priority: GoalPriority?

    var body: some View {
        Text(priority?.rawValue ?? "Normal")
            .appFont(style: .caption)
            .padding(.horizontal, AppSpacing.medium)
            .padding(.vertical, AppSpacing.small)
            .background((priority?.color ?? .gray).opacity(0.2))
            .foregroundColor(priority?.color ?? .gray)
            .cornerRadius(AppSpacing.small)
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.small)
                    .stroke((priority?.color ?? .gray), lineWidth: 1)
            )
    }
}

struct PriorityTagView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.medium) {
            PriorityTagView(priority: .low)
            PriorityTagView(priority: .normal)
            PriorityTagView(priority: .high)
            PriorityTagView(priority: nil)
        }
        .padding()
        .background(AppColors.background)
    }
}
