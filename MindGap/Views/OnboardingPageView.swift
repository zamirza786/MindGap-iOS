import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250) // Placeholder size
                .padding(.bottom, 20)

            Text(page.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("MGAccent")) // Using existing AppColors
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text(page.description)
                .font(.title2)
                .foregroundColor(.gray) // Using existing AppColors
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnboardingPageView(page: OnboardingPage(title: "Welcome", description: "This is a description.", imageName: "onboarding_illustration_1"))
}
