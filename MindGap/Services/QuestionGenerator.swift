import Foundation

/// A service responsible for loading and providing the daily question.
final class QuestionGenerator {

    private var questions: [Question] = []

    /// The daily question, consistent for any 24-hour period.
    var dailyQuestion: Question {
        // Use the current day to select a consistent question.
        let dayIndex = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 0
        let questionIndex = dayIndex % questions.count
        return questions[questionIndex]
    }

    init() {
        self.questions = loadQuestions()
    }

    /// Loads questions from the bundled `Questions.json` file.
    /// - Returns: An array of `Question` objects.
    private func loadQuestions() -> [Question] {
        guard let url = Bundle.main.url(forResource: "Questions", withExtension: "json") else {
            fatalError("Fatal Error: Questions.json file not found.")
        }

        do {
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([Question].self, from: data)
            return questions
        } catch {
            fatalError("Fatal Error: Could not load or decode Questions.json: \(error)")
        }
    }
}