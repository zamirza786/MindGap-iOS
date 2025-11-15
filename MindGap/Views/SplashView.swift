import SwiftUI

struct SplashView: View {
    @Binding var showSplash: Bool // Binding to control splash screen visibility
    @State private var opacity = 0.0
    @State private var scale: CGFloat = 0.8

    // Duration for the splash screen animation
    let splashScreenDuration: Double = 1.2

    var body: some View {
        VStack {
            Image("LaunchImage") // Using the LaunchImage asset
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .opacity(opacity)
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.easeIn(duration: splashScreenDuration / 2)) {
                        opacity = 1.0
                        scale = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + splashScreenDuration / 2) {
                        withAnimation(.easeOut(duration: splashScreenDuration / 2)) {
                            // Optional: Add a slight glow or further scale before disappearing
                            // For a glow, you might need a custom shader or overlay
                            // For simplicity, I'll just scale slightly more before fading out
                            scale = 1.1
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + splashScreenDuration) {
                        self.showSplash = false // Dismiss splash screen
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea()) // Using AppColors for background

    }
}

#Preview {
    // Provide a constant binding for preview
    SplashView(showSplash: .constant(true))
}
