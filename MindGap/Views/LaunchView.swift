import SwiftUI

/// The main launch view of the app.
/// This view is now a simple wrapper around the MainTabView.
struct LaunchView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    LaunchView()
        .environmentObject(ThemeManager())
}
