import SwiftUI

struct MoodSummaryView: View {
    @ObservedObject var viewModel: MoodTrackerViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: AppSpacing.xlarge) {
            Text("Your mood is saved!")
                .appFont(style: .headline)

            AppIcon("checkmark.circle.fill", size: 96)
                .foregroundColor(AppColors.accent)

            Button("Done") {
                viewModel.saveMood()
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(AppButtonStyle(style: .primary()))
        }
        .padding()
        .background(AppColors.background)
        .navigationBarHidden(true)
    }
}

struct MoodSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        MoodSummaryView(viewModel: MoodTrackerViewModel())
    }
}
