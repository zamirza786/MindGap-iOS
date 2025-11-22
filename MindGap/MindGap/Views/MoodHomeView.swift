import SwiftUI

struct MoodHomeView: View {
    @StateObject private var viewModel = MoodHomeViewModel()
    @StateObject private var moodTrackerViewModel = MoodTrackerViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.large) {
                // Greeting
                Text("How are you feeling today?")
                    .appFont(style: .headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Start Mood Check-In Button
                NavigationLink(destination: MoodSelectionView(viewModel: moodTrackerViewModel)) {
                    Text("Start Mood Check-In")
                }
                .buttonStyle(AppButtonStyle(style: .primary()))

                // Recent Mood History
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    Text("Recent Moods")
                        .appFont(style: .subheadline)
                        .padding(.horizontal)

                    ForEach(viewModel.recentMoods) { mood in
                        MoodHistoryCard(mood: mood)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
            .background(AppColors.background)
            .navigationTitle("Mood Tracker")
        }
    }
}

struct MoodHistoryCard: View {
    let mood: Mood

    var body: some View {
        HStack {
            AppIcon(mood.moodType.icon, size: 32)
                .foregroundColor(AppColors.accent)
            
            VStack(alignment: .leading) {
                Text(mood.moodType.rawValue)
                    .appFont(style: .body)
                Text(mood.timestamp, style: .date)
                    .appFont(style: .caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Text(String(format: "%.0f%%", mood.intensity * 100))
                .appFont(style: .body)
        }
        .padding()
        .appCard()
    }
}

struct MoodHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MoodHomeView()
            .environmentObject(ThemeManager())
    }
}
