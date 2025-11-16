import SwiftUI

public struct AppButtonStyle: ButtonStyle {
    public enum Style {
        case primary
        case secondary
        case ghost
    }

    let style: Style

    public func makeBody(configuration: Configuration) -> some View {
        switch style {
        case .primary:
            PrimaryButton(configuration: configuration)
        case .secondary:
            SecondaryButton(configuration: configuration)
        case .ghost:
            GhostButton(configuration: configuration)
        }
    }
}

private struct PrimaryButton: View {
    let configuration: ButtonStyle.Configuration

    var body: some View {
        configuration.label
            .appFont(style: .button)
            .foregroundColor(AppColors.background)
            .padding(.vertical, AppSpacing.medium)
            .padding(.horizontal, AppSpacing.large)
            .background(AppColors.gradient)
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
