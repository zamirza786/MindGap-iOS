import Foundation

/// The ViewModel for the `DailyQuestionView`.
///
/// It provides the daily question and handles the logic for saving the user's reflection.
@MainActor
final class DailyQuestionViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var dailyQuestion: Question
    @Published var userAnswer: String = ""
    @Published var selectedMood: ReflectionEntry.Mood = .neutral
    @Published private(set) var hasAnsweredToday: Bool = false

    // MARK: - Services
    private let questionGenerator: QuestionGenerator
    private let dataManager: DataManager
    
    init(questionGenerator: QuestionGenerator, dataManager: DataManager) {
        self.questionGenerator = questionGenerator
        self.dataManager = dataManager
        self.dailyQuestion = questionGenerator.dailyQuestion
        
        // Check if the user has already answered the question for today.
        self.checkForExistingEntry()
    }

    /// Checks if a reflection entry already exists for the current day.
    private func checkForExistingEntry() {
        let hasEntry = dataManager.reflections.contains { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: .now)
        }
        self.hasAnsweredToday = hasEntry
        
        if hasEntry {
            // If an entry for today already exists, load its data to show the user.
            if let todayEntry = dataManager.reflections.first(where: { Calendar.current.isDate($0.date, inSameDayAs: .now) }) {
                self.userAnswer = todayEntry.answer
                self.selectedMood = todayEntry.mood
            }
        }
    }

    /// Saves the user's reflection.
    func saveReflection() {
        guard !userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Cannot save an empty answer.")
            return
        }
        
        let newEntry = ReflectionEntry(
            question: dailyQuestion.text,
            answer: userAnswer,
            mood: selectedMood
        )
        
        dataManager.saveReflection(newEntry)
        print("Reflection saved successfully.")
    }
}
