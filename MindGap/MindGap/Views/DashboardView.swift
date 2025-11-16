import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                // Greeting
                Text(viewModel.greeting)
                    .appFont(style: .headline)
                    .padding(.horizontal)

                // Mood Check-in
                MoodCheckInCard()
                    .padding(.horizontal)

                // Weekly Mood Summary
                WeeklyMoodCard(moods: viewModel.weeklyMoods)
                    .padding(.horizontal)

                // Today's Reflection
                ReflectionCard(prompt: viewModel.reflectionPrompt)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(AppColors.background)
    }
}

struct MoodCheckInCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("How are you feeling?")
                .appFont(style: .subheadline)
            
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Button(action: {}) {
                        AppIcon("smiley", size: 32)
                    }
                }
            }
        }
        .padding()
        .appCard()
    }
}

struct WeeklyMoodCard: View {
    let moods: [Double]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Weekly Mood")
                .appFont(style: .subheadline)
            
            HStack(alignment: .bottom, spacing: AppSpacing.small) {
                ForEach(moods.indices, id: \.self) { index in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.accent.opacity(moods[index]))
                            .frame(height: CGFloat(moods[index]) * 100)
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

struct ReflectionCard: View {
    let prompt: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Today's Reflection")
                .appFont(style: .subheadline)
            
            Text(prompt)
                .appFont(style: .body)
            
            Button("Reflect Now") {}
                .buttonStyle(AppButtonStyle(style: .primary))
        }
        .padding()
        .appCard()
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
