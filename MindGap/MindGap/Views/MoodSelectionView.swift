import SwiftUI

struct MoodSelectionView: View {
    @ObservedObject var viewModel: MoodTrackerViewModel

    var body: some View {
        VStack(spacing: AppSpacing.xlarge) {
            Text("How are you feeling?")
                .appFont(style: .headline)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: AppSpacing.large) {
                ForEach(MoodType.allCases, id: \.self) { moodType in
                    NavigationLink(destination: MoodIntensityView(viewModel: viewModel)) {
                        VStack {
                            AppIcon(moodType.icon, size: 48)
                                .foregroundColor(AppColors.accent)
                            Text(moodType.rawValue)
                                .appFont(style: .caption)
                        }
                        .padding()
                        .background(AppColors.card)
                        .cornerRadius(AppSpacing.medium)
                        .appShadow(.small)
                        .onTapGesture {
                            viewModel.selectedMood = moodType
                        }
                    }
                }
            }
        }
        .padding()
        .background(AppColors.background)
        .navigationTitle("Select Mood")
    }
}

struct MoodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MoodSelectionView(viewModel: MoodTrackerViewModel())
    }
}
