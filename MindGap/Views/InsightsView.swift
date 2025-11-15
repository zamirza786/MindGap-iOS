import SwiftUI

/// A view that displays analytics and trends based on the user's mood data.
struct InsightsView: View {
    
    @StateObject var viewModel: InsightsViewModel
    @State private var showPurchaseView = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    if viewModel.totalReflections == 0 {
                        emptyStateView
                    } else {
                        if let summary = viewModel.moodSummary {
                            moodDistributionChart(summary: summary)
                        }
                        
                        if let message = viewModel.limitedDataMessage {
                            premiumUpsellView(message: message)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Insights")
            .background(AppColors.background.ignoresSafeArea())
            .sheet(isPresented: $showPurchaseView) {
                // The PurchaseView will be created next.
                // For now, a placeholder.
                Text("Purchase View Placeholder")
            }
        }
    }
    
    /// A view to show when there is no data to analyze.
    private var emptyStateView: some View {
        VStack {
            Text("Not Enough Data")
                .font(.headline)
            Text("Start reflecting daily to see your mood trends here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 200, alignment: .center)
    }
    
    /// A chart displaying the distribution of moods.
    private func moodDistributionChart(summary: MoodAnalytics.MoodSummary) -> some View {
        VStack(alignment: .leading) {
            Text("Mood Distribution")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack(alignment: .bottom, spacing: 12) {
                chartBar(mood: .happy, percentage: summary.happyPercentage)
                chartBar(mood: .neutral, percentage: summary.neutralPercentage)
                chartBar(mood: .sad, percentage: summary.sadPercentage)
            }
            .frame(height: 150)
            .padding(.top)
            
            if let dominantMood = summary.dominantMood {
                Text("Your dominant mood has been \(dominantMood.rawValue).")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    /// A single bar in the mood distribution chart.
    private func chartBar(mood: ReflectionEntry.Mood, percentage: Double) -> some View {
        VStack {
            Rectangle()
                .fill(AppColors.accent.opacity(0.7))
                .frame(height: max(0, CGFloat(percentage) * 1.5)) // Scale height
            
            Text(mood.emoji)
                .font(.title)
            
            Text(String(format: "%.0f%%", percentage))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    /// A view to encourage users to upgrade to premium.
    private func premiumUpsellView(message: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Unlock Your Full Potential")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Button(action: { showPurchaseView = true }) {
                Text("Go Premium")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(AppColors.accent)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

//#Preview {
//    // Create mock services for the preview
//    let dataManager = DataManager()
//    dataManager.reflections = [
//        ReflectionEntry(mood: .happy),
//        ReflectionEntry(mood: .happy),
//        ReflectionEntry(mood: .neutral),
//        ReflectionEntry(mood: .sad)
//    ]
//    let premiumManager = PremiumManager()
//    let viewModel = InsightsViewModel(dataManager: dataManager, premiumManager: premiumManager)
//    
//    InsightsView(viewModel: viewModel)
//}
