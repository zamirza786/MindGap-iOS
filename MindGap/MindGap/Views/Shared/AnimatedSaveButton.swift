import SwiftUI

struct AnimatedSaveButton: View {
    let viewModel: AddEditGoalViewModel
    let saveAction: () -> Void
    
    @State private var buttonScale: CGFloat = 1.0
    @State private var showSuccessCheckmark: Bool = false

    var body: some View {
        Button(action: {
            saveAction()
            if viewModel.isFormValid {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    buttonScale = 0.95
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        buttonScale = 1.0
                        showSuccessCheckmark = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showSuccessCheckmark = false
                }
            }
        }) {
            HStack {
                if viewModel.isSaving {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColors.background))
                } else if showSuccessCheckmark {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                } else {
                    Text(viewModel.saveButtonText)
                        .appFont(style: .button)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.medium)
            .background(
                AppColors.gradient(for: AppColors.theme(for: viewModel.progress))
            )
            .foregroundColor(AppColors.background)
            .cornerRadius(AppSpacing.medium)
            .appShadow(.medium)
        }
        .scaleEffect(buttonScale)
        .disabled(!viewModel.isFormValid || viewModel.isSaving)
        .padding(.horizontal, AppSpacing.large)
        .padding(.bottom, AppSpacing.large)
        .animation(.spring, value: viewModel.isFormValid)
        .transition(.move(edge: .bottom))
    }
}

struct AnimatedSaveButton_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock storage and view model for preview
        let mockStorage = MockGoalStorage()
        let viewModel = AddEditGoalViewModel(mode: .add, storage: mockStorage)
        
        return AnimatedSaveButton(viewModel: viewModel, saveAction: {
            print("Save action triggered")
            viewModel.saveGoal()
        })
        .environmentObject(ThemeManager())
    }
}
