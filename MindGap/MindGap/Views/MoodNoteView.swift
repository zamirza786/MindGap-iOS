import SwiftUI

struct MoodNoteView: View {
    @ObservedObject var viewModel: MoodTrackerViewModel

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Text("Add a note (optional)")
                .appFont(style: .headline)

            TextEditor(text: $viewModel.note)
                .appFont(style: .body)
                .frame(height: 150)
                .padding(AppSpacing.small)
                .background(AppColors.card)
                .cornerRadius(AppSpacing.small)
                .appShadow(.small)

            NavigationLink(destination: MoodSummaryView(viewModel: viewModel)) {
                Text("Save Mood")
            }
            .buttonStyle(AppButtonStyle(style: .primary))
        }
        .padding()
        .background(AppColors.background)
        .navigationTitle("Note")
    }
}

struct MoodNoteView_Previews: PreviewProvider {
    static var previews: some View {
        MoodNoteView(viewModel: MoodTrackerViewModel())
    }
}
