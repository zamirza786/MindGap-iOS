import SwiftUI

struct DailyQuestionView: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var viewModel: DailyQuestionViewModel
    
    @State private var navigateToJournal = false
    @State private var showSaveConfirmation = false

    init() {
        _viewModel = StateObject(wrappedValue: DailyQuestionViewModel(
            questionGenerator: QuestionGenerator(),
            dataManager: DataManager.shared
        ))
    }

    var body: some View {
        VStack(spacing: 20) {
            if viewModel.hasAnsweredToday {
                answeredView
            } else {
                questionView
            }
        }
        .navigationTitle(Date.now.formattedDate)
        .padding()
        .background(AppColors.background.ignoresSafeArea())
        .navigationDestination(isPresented: $navigateToJournal) {
            JournalView()
        }
        .toast(isShowing: $showSaveConfirmation, message: "Reflection Saved!")
    }

    @ViewBuilder
    private var questionView: some View {
        VStack(spacing: 25) {
            Text(viewModel.dailyQuestion.text)
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextEditor(text: $viewModel.userAnswer)
                .font(.body)
                .padding(10)
                .frame(height: 150)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)

            MoodSelector(selectedMood: $viewModel.selectedMood)

            Button(action: {
                viewModel.saveReflection()
                withAnimation {
                    showSaveConfirmation = true
                }
                // Navigate after a short delay to allow the user to see the confirmation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    navigateToJournal = true
                }
            }) {
                Text("Save Reflection")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.accent)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var answeredView: some View {
        VStack(spacing: 20) {
            Text("Thank you for reflecting today.")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Come back tomorrow for a new question.")
                .font(.body)
                .foregroundStyle(AppColors.secondaryText)
            
            Spacer()
            
            NavigationLink(destination: JournalView()) {
                Text("View Journal")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.accent)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        DailyQuestionView()
            .environmentObject(DataManager.shared)
    }
}