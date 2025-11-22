import SwiftUI

public enum AppColors {
    public static let background = Color("MGBackground")
    public static let accent = Color("MGAccent")
    public static let text = Color("MGText")
    public static let textSecondary = Color("MGTextSecondary")
    public static let card = Color("MGCard")
    public static let shadow = Color("MGShadow").opacity(0.1)

    public static let defaultGradient = LinearGradient(
        gradient: Gradient(colors: [accent.opacity(0.8), accent]),
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Goal Progress Theming
    public enum GoalProgressTheme {
        case low, medium, high
    }

    public struct GradientTheme {
        let colors: [Color]
    }

    public static func theme(for progress: Double) -> GoalProgressTheme {
        if progress <= 0.30 {
            return .low
        } else if progress <= 0.70 {
            return .medium
        } else {
            return .high
        }
    }

    public static func gradient(for theme: GoalProgressTheme) -> Gradient {
        switch theme {
        case .low:
            return Gradient(colors: [Color.red.opacity(0.7), Color.orange.opacity(0.8)])
        case .medium:
            return Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.8)])
        case .high:
            return Gradient(colors: [Color.green.opacity(0.7), Color.teal.opacity(0.8)])
        }
    }
    
    public static func color(for theme: GoalProgressTheme) -> Color {
        switch theme {
        case .low: return Color.red
        case .medium: return Color.blue
        case .high: return Color.green
        }
    }
}
