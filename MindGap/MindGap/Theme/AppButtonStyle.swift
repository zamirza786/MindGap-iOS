import SwiftUI

public struct AppButtonStyle: ButtonStyle {
    public enum Style {
        case primary(gradient: LinearGradient? = nil) // Add optional gradient
        case secondary
        case ghost
        case destructive
    }

    let style: Style

    public func makeBody(configuration: Configuration) -> some View {
        switch style {
        case .primary(let gradient):
            PrimaryButton(configuration: configuration, gradient: gradient)
        case .secondary:
            SecondaryButton(configuration: configuration)
        case .ghost:
            GhostButton(configuration: configuration)
        case .destructive:
            DestructiveButton(configuration: configuration)
        }
    }
}

private struct PrimaryButton: View {
    let configuration: ButtonStyle.Configuration
    let gradient: LinearGradient? // Accept optional gradient

    var body: some View {
        configuration.label
            .appFont(style: .button)
            .foregroundColor(AppColors.background)
            .padding(.vertical, AppSpacing.medium)
            .padding(.horizontal, AppSpacing.large)
            .background(gradient ?? AppColors.defaultGradient) // Use passed gradient or default
            .cornerRadius(AppSpacing.small)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

private struct DestructiveButton: View {
    let configuration: ButtonStyle.Configuration

    var body: some View {
        configuration.label
            .appFont(style: .button)
            .foregroundColor(.white)
            .padding(.vertical, AppSpacing.medium)
            .padding(.horizontal, AppSpacing.large)
            .background(Color.red)
            .cornerRadius(AppSpacing.small)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

private struct SecondaryButton: View {
    let configuration: ButtonStyle.Configuration

    var body: some View {
        configuration.label
            .appFont(style: .button)
            .foregroundColor(AppColors.accent)
            .padding(.vertical, AppSpacing.medium)
            .padding(.horizontal, AppSpacing.large)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.small)
                    .stroke(AppColors.accent, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

private struct GhostButton: View {
    let configuration: ButtonStyle.Configuration

    var body: some View {
        configuration.label
            .appFont(style: .button)
            .foregroundColor(AppColors.accent)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
