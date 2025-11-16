import SwiftUI

struct MoodIntensityView: View {
    @ObservedObject var viewModel: MoodTrackerViewModel

    var body: some View {
        VStack(spacing: AppSpacing.xlarge) {
            Text("How intense is this feeling?")
                .appFont(style: .headline)

            Slider(value: $viewModel.intensity, in: 0...1)
                .accentColor(AppColors.accent)

            NavigationLink(destination: MoodNoteView(viewModel: viewModel)) {
                Text("Continue")
            }
            .buttonStyle(AppButtonStyle(style: .primary))
        }
        .padding()
        .background(AppColors.background)
        .navigationTitle("Intensity")
    }
}

struct MoodIntensityView_Previews: PreviewProvider {
    static var previews: some View {
        MoodIntensityView(viewModel: MoodTrackerViewModel())
    }
}
