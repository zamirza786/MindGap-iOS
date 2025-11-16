import SwiftUI

public enum AppShadows {
    case small
    case medium
    case large
}

public struct Shadow: ViewModifier {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    public func body(content: Content) -> some View {
        content.shadow(color: color, radius: radius, x: x, y: y)
    }
}

extension View {
    public func appShadow(_ style: AppShadows) -> some View {
        switch style {
        case .small:
            return self.modifier(Shadow(color: AppColors.shadow, radius: 4, x: 0, y: 2))
        case .medium:
            return self.modifier(Shadow(color: AppColors.shadow, radius: 8, x: 0, y: 4))
        case .large:
            return self.modifier(Shadow(color: AppColors.shadow, radius: 16, x: 0, y: 8))
        }
    }
}
