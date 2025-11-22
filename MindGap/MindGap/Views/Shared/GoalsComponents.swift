import SwiftUI

// MARK: - ProgressRingView
struct ProgressRingView: View {
    let progress: Double // 0.0 to 1.0
    var thickness: CGFloat = 12
    var width: CGFloat = 150

    var body: some View {
        let currentTheme = AppColors.theme(for: progress)
        
        ZStack {
            Circle()
                .stroke(AppColors.card, lineWidth: thickness) // Background track
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(AppColors.gradient(for: currentTheme), style: StrokeStyle(lineWidth: thickness, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 1.0, dampingFraction: 0.8, blendDuration: 1.0), value: progress) // Smooth spring animation
            
            Text("\(Int(progress * 100))%")
                .appFont(style: .subheadline)
                .fontWeight(.bold)
                .foregroundColor(AppColors.color(for: currentTheme)) // Dynamic text color
        }
        .frame(width: width, height: width)
        .appShadow(.medium) // Shadow for depth
    }
}

// MARK: - GoalCategoryIconView
struct GoalCategoryIconView: View {
    let category: GoalCategory
    var size: CGFloat = 24

    var body: some View {
        AppIcon(category.icon, size: size)
            .foregroundColor(AppColors.accent)
    }
}

// MARK: - EmptyStateView
struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let message: String
    let action: (() -> Void)? // Optional action for a button

    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(AppColors.textSecondary)
            
            Text(title)
                .appFont(style: .subheadline)
                .foregroundColor(AppColors.text)
            
            Text(message)
                .appFont(style: .body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            if let action = action {
                Button("Add First Goal") {
                    action()
                }
                .buttonStyle(AppButtonStyle(style: .primary()))
                .padding(.top, AppSpacing.medium)
            }
        }
        .padding(AppSpacing.xlarge)
        .frame(maxWidth: .infinity)
        .appCard()
        .appShadow(.medium) // Slightly stronger shadow
    }
}
