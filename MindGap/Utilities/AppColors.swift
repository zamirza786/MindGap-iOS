import SwiftUI

/// A struct to hold the app's custom color palette.
///
/// These colors should be defined in your `Assets.xcassets` file
/// to be available at runtime.
struct AppColors {
    
    /// The primary background color for most views.
    /// A light, neutral, and calming tone.
    static let background = Color("MGBackground")
    
    /// The accent color for buttons, highlights, and important UI elements.
    /// A calming blue or lavender tone.
    static let accent = Color("MGAccent")
    
    /// A secondary color for text or less important elements.
    static let secondaryText = Color.gray

    /// A linear gradient for the background, using MGBackground color.
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color("MGBackground"), Color("MGBackground").opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// A linear gradient for accent elements, using MGAccent color.
    static let accentGradient = LinearGradient(
        gradient: Gradient(colors: [Color("MGAccent"), Color("MGAccent").opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}