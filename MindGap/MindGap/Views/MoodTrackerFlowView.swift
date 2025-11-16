import SwiftUI

struct MoodTrackerFlowView: View {
    @StateObject private var viewModel = MoodTrackerViewModel()

    var body: some View {
        NavigationStack {
            MoodSelectionView(viewModel: viewModel)
        }
    }
}

struct MoodTrackerFlowView_Previews: PreviewProvider {
    static var previews: some View {
        MoodTrackerFlowView()
    }
}
