import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var greeting: String = "Good morning, Zack"
    @Published var weeklyMoods: [Double] = [0.8, 0.6, 0.9, 0.7, 0.5, 0.8, 0.9]
    @Published var reflectionPrompt: String = "What is one thing you're grateful for today?"

    init() {
        updateGreeting()
    }

    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            greeting = "Good morning, Zack"
        case 12..<18:
            greeting = "Good afternoon, Zack"
        default:
            greeting = "Good evening, Zack"
        }
    }
}
