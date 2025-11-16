import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            MoodHomeView()
                .tabItem {
                    Label("Mood", systemImage: "smiley.fill")
                }

            JournalHomeView()
                .tabItem {
                    Label("Journal", systemImage: "book.fill")
                }

            Text("Profile Screen")
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            
            NavigationView { // Use NavigationView for the settings tab
                ReminderSettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
        .accentColor(AppColors.accent)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(ThemeManager())
    }
}
