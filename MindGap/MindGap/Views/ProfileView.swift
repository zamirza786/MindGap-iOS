import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.medium) {
                ProfileHeaderView(userName: viewModel.userName)
                    .padding(.horizontal)

                // Streaks
                HStack(spacing: AppSpacing.medium) {
                    StreakCardView(
                        title: "Mood Streak",
                        currentStreak: viewModel.currentMoodStreak,
                        longestStreak: viewModel.longestMoodStreak,
                        icon: "face.smiling.fill"
                    )
                    StreakCardView(
                        title: "Journal Streak",
                        currentStreak: viewModel.currentJournalStreak,
                        longestStreak: viewModel.longestJournalStreak,
                        icon: "book.closed.fill"
                    )
                }
                .padding(.horizontal)

                // Quick Stats
                VStack(spacing: AppSpacing.medium) {
                    StatsCardView(
                        title: "Total Mood Check-ins",
                        value: "\(viewModel.totalMoodCheckIns)",
                        icon: "checkmark.circle.fill"
                    )
                    StatsCardView(
                        title: "Total Journal Entries",
                        value: "\(viewModel.totalJournalEntries)",
                        icon: "text.book.closed.fill"
                    )
                    StatsCardView(
                        title: "Average Weekly Mood",
                        value: String(format: "%.1f", viewModel.averageWeeklyMood * 10), // Scale 0-1 to 0-10
                        icon: "gauge.high"
                    )
                }
                .padding(.horizontal)

                // Weekly Graphs
                WeeklyChartView(
                    title: "Weekly Mood Trend",
                    values: viewModel.weeklyMoodValues,
                    maxValue: 1.0 // Mood values are 0-1
                )
                .padding(.horizontal)

                WeeklyChartView(
                    title: "Weekly Journal Activity",
                    values: viewModel.weeklyJournalValues,
                    maxValue: 3.0 // Assuming max 3 entries per day for scaling
                )
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(AppColors.background)
        .navigationTitle("Profile")
        .onAppear {
            viewModel.loadData(modelContext: modelContext)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: JournalEntry.self, configurations: config)
        
        return ProfileView()
            .environmentObject(ThemeManager())
            .modelContainer(container)
    }
}
