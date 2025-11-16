import SwiftUI

public enum AppColors {
    public static let background = Color("MGBackground")
    public static let accent = Color("MGAccent")
    public static let text = Color("MGText")
    public static let textSecondary = Color("MGTextSecondary")
    public static let card = Color("MGCard")
    public static let shadow = Color("MGShadow").opacity(0.1)

    public static let gradient = LinearGradient(
        gradient: Gradient(colors: [accent.opacity(0.8), accent]),
        startPoint: .top,
        endPoint: .bottom
    )
}
