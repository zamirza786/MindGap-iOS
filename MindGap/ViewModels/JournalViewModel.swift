import Foundation

/// The ViewModel for the `JournalView`.
///
/// It provides the list of past reflection entries for display.
@MainActor
final class JournalViewModel: ObservableObject {

    /// The list of reflection entries, sourced from the `DataManager`.
    @Published var reflections: [ReflectionEntry] = []
    
    private let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.reflections = dataManager.reflections
    }
    
    /// A computed property to group reflections by month and year for sectioned lists.
    var groupedReflections: [String: [ReflectionEntry]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy" // e.g., "November 2025"
        
        return Dictionary(grouping: reflections) { entry in
            formatter.string(from: entry.date)
        }
    }
    
    var sortedMonthKeys: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        return groupedReflections.keys.sorted {
            guard let date1 = formatter.date(from: $0), let date2 = formatter.date(from: $1) else {
                return false
            }
            return date1 > date2
        }
    }
}
