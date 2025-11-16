import SwiftUI

struct DesignSystemSampleView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.large) {
                // Gradient Background
                ZStack {
                    AppColors.gradient
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Calm & Minimal")
                            .appFont(style: .headline)
                            .foregroundColor(AppColors.background)
                        Text("A premium wellness aesthetic.")
                            .appFont(style: .subheadline)
                            .foregroundColor(AppColors.background.opacity(0.8))
                    }
                }
                .frame(height: 200)

                // Text Styles
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    Text("Headlines")
                        .appFont(style: .headline)
                    Text("Subheadlines")
                        .appFont(style: .subheadline)
                    Text("Body text for descriptions and content.")
                        .appFont(style: .body)
                    Text("Captions for small details.")
                        .appFont(style: .caption)
                }
                .padding()

                // Buttons
                VStack(spacing: AppSpacing.medium) {
                    Button("Primary Button") {}
                        .buttonStyle(AppButtonStyle(style: .primary))
                    Button("Secondary Button") {}
                        .buttonStyle(AppButtonStyle(style: .secondary))
                    Button("Ghost Button") {}
                        .buttonStyle(AppButtonStyle(style: .ghost))
                }
                .padding()

                // Card
                VStack {
                    Text("Sample Card")
                        .appFont(style: .subheadline)
                        .padding()
                    
                    Text("This is a sample card using the AppCardStyle. It has a subtle shadow and rounded corners.")
                        .appFont(style: .body)
                        .padding()
                }
                .appCard()
                .padding()
                
                // Icons
                HStack(spacing: AppSpacing.large) {
                    AppIcon("heart.fill", size: 32)
                        .foregroundColor(AppColors.accent)
                    AppIcon("star.fill", size: 32)
                        .foregroundColor(AppColors.accent)
                    AppIcon("bell.fill", size: 32)
                        .foregroundColor(AppColors.accent)
                }
                .padding()

                // Toggle for Dark Mode
                Toggle(isOn: Binding(
                    get: { themeManager.colorScheme == .dark },
                    set: { themeManager.colorScheme = $0 ? .dark : .light }
                )) {
                    Text("Enable Dark Mode")
                        .appFont(style: .body)
                }
                .padding()

            }
        }
        .background(AppColors.background)
        .foregroundColor(AppColors.text)
    }
}

struct DesignSystemSampleView_Previews: PreviewProvider {
    static var previews: some View {
        DesignSystemSampleView()
            .environmentObject(ThemeManager())
    }
}
