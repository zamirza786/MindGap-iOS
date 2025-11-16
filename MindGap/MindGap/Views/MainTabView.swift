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

            NavigationView { // Use NavigationView for the profile tab
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
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
