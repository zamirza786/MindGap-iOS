import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.presentationMode) var presentationMode // To dismiss the sheet if presented

    var body: some View {
        VStack {
            TabView(selection: $viewModel.currentPageIndex) {
                ForEach(viewModel.pages.indices, id: \.self) { index in
                    OnboardingPageView(page: viewModel.pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .animation(.easeInOut, value: viewModel.currentPageIndex) // Smooth fade/slide animation

            HStack {
                if !viewModel.isLastPage {
                    Button("Skip") {
                        viewModel.skipOnboarding()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .foregroundColor(AppColors.accent) // Using existing AppColors
                }

                Spacer()

                Button(viewModel.isLastPage ? "Get Started" : "Next") {
                    if viewModel.isLastPage {
                        viewModel.getStarted()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        viewModel.goToNextPage()
                    }
                }
                .buttonStyle(PrimaryButtonStyle()) // Assuming a PrimaryButtonStyle exists or will be created
                .padding()
            }
            .padding(.horizontal)
        }
        .background(AppColors.background.ignoresSafeArea()) // Using existing AppColors
    }
}

// Placeholder ButtonStyle - assuming it exists or will be created
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppColors.accent) // Using existing AppColors
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    OnboardingView()
}
