import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            Text("Mood Screen")
                .tabItem {
                    Label("Mood", systemImage: "smiley.fill")
                }

            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book.fill")
                }

            Text("Profile Screen")
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
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
