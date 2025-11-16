import SwiftUI

public struct AppCardStyle: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(AppColors.card)
            .cornerRadius(AppSpacing.medium)
            .appShadow(.small)
    }
}

extension View {
    public func appCard() -> some View {
        self.modifier(AppCardStyle())
    }
}
