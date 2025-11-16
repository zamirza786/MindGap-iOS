import SwiftUI

/// The main launch view of the app, containing the tab bar.
///
/// This view is responsible for initializing and injecting all major services
/// and view models into the SwiftUI environment.
struct LaunchView: View {

    // MARK: - State Objects
    // These objects are the single source of truth for their respective domains.
    // They are created once here and passed down through the environment or as parameters.
    
    @StateObject private var dataManager = DataManager.shared
    
    // The QuestionGenerator is a plain class, not an ObservableObject,
    // as it doesn't need to publish changes.
    private let questionGenerator = QuestionGenerator()

    var body: some View {
        TabView {
            // Tab 1: Daily Question
            NavigationStack{
                DailyQuestionView()
            }
            .tabItem {
                Label("Today", systemImage: "sun.max.fill")
            }
            
            // Tab 2: Journal
            NavigationStack{
                JournalView()
            }
            .tabItem {
                Label("Journal", systemImage: "book.fill")
            }
            
            // Tab 3: History
            NavigationStack{
                HistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock.fill")
            }
            
            // Tab 4: Design System
            NavigationStack{
                DesignSystemSampleView()
            }
            .tabItem {
                Label("Theme", systemImage: "paintbrush.fill")
            }
        }
        // Inject managers into the environment so nested views can access them.
        .environmentObject(dataManager)
        .accentColor(AppColors.accent)
    }
}

#Preview {
    LaunchView()
}
