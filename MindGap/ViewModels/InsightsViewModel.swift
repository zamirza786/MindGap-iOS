import Foundation
import Combine

/// The ViewModel for the `InsightsView`.
///
/// It processes reflection data to generate analytics and respects the user's premium status.
@MainActor
final class InsightsViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published private(set) var moodSummary: MoodAnalytics.MoodSummary?
    @Published private(set) var isPremium: Bool = false
    @Published private(set) var totalReflections: Int = 0

    // MARK: - Services
    private let dataManager: DataManager
    private let premiumManager: PremiumManager
    
    private var cancellables = Set<AnyCancellable>()

    init(dataManager: DataManager, premiumManager: PremiumManager) {
        self.dataManager = dataManager
        self.premiumManager = premiumManager
        
        // Subscribe to premium status changes.
        premiumManager.$isPremium
            .assign(to: \.isPremium, on: self)
            .store(in: &cancellables)
        
        // Subscribe to reflection data changes and re-calculate analytics.
        dataManager.$reflections
            .sink { [weak self] reflections in
                self?.updateAnalytics(with: reflections)
            }
            .store(in: &cancellables)
    }

    /// Updates the analytics based on the provided reflection entries.
    private func updateAnalytics(with reflections: [ReflectionEntry]) {
        self.totalReflections = reflections.count
        
        // The free version might show analytics for the last 7 days.
        let analyticsPeriod = isPremium ? reflections : filterLastWeek(reflections)
        
        self.moodSummary = MoodAnalytics.generateSummary(for: analyticsPeriod)
    }
    
    /// Filters reflections to only include those from the last 7 days.
    private func filterLastWeek(_ reflections: [ReflectionEntry]) -> [ReflectionEntry] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now)!
        return reflections.filter { $0.date >= sevenDaysAgo }
    }
    
    var limitedDataMessage: String? {
        if !isPremium && totalReflections > 0 {
            return "Unlock Premium to see analytics for all your reflections. Currently showing last 7 days."
        }
        return nil
    }
}
