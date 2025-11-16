import SwiftUI

// MARK: - ProfileHeaderView
struct ProfileHeaderView: View {
    let userName: String
    
    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(AppColors.accent)
            
            Text(userName)
                .appFont(style: .headline)
        }
        .padding(.vertical, AppSpacing.large)
        .frame(maxWidth: .infinity)
        .background(AppColors.card)
        .cornerRadius(AppSpacing.medium)
        .appShadow(.small)
    }
}

// MARK: - StreakCardView
struct StreakCardView: View {
    let title: String
    let currentStreak: Int
    let longestStreak: Int
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack {
                AppIcon(icon, size: 24)
                    .foregroundColor(AppColors.accent)
                Text(title)
                    .appFont(style: .subheadline)
            }
            
            Text("\(currentStreak) Day Streak")
                .appFont(style: .body)
                .fontWeight(.bold)
            
            Text("Longest: \(longestStreak) days")
                .appFont(style: .caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard()
    }
}

// MARK: - StatsCardView
struct StatsCardView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            AppIcon(icon, size: 24)
                .foregroundColor(AppColors.accent)
            
            VStack(alignment: .leading) {
                Text(title)
                    .appFont(style: .body)
                    .foregroundColor(AppColors.textSecondary)
                Text(value)
                    .appFont(style: .subheadline)
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard()
    }
}

// MARK: - WeeklyChartView
struct WeeklyChartView: View {
    let title: String
    let values: [Double] // Values between 0 and 1 for mood, or counts for journal
    let maxValue: Double // Max value for scaling the bars

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text(title)
                .appFont(style: .subheadline)
            
            HStack(alignment: .bottom, spacing: AppSpacing.small) {
                ForEach(values.indices, id: \.self) { index in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.accent.opacity(values[index] / maxValue))
                            .frame(height: CGFloat(values[index] / maxValue) * 80) // Scale height
                        Text(["S", "M", "T", "W", "T", "F", "S"][index])
                            .appFont(style: .caption)
                    }
                }
            }
        }
        .padding()
        .appCard()
    }
}
