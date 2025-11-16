import SwiftUI

public enum AppTypography {
    public static func font(style: TextStyle, size: CGFloat) -> Font {
        return .system(size: size)
    }

    public enum TextStyle {
        case headline
        case subheadline
        case body
        case caption
        case button
    }

    public static func headline() -> Font {
        return font(style: .headline, size: 28).weight(.bold)
    }

    public static func subheadline() -> Font {
        return font(style: .subheadline, size: 22).weight(.semibold)
    }

    public static func body() -> Font {
        return font(style: .body, size: 17)
    }

    public static func caption() -> Font {
        return font(style: .caption, size: 12).weight(.medium)
    }

    public static func button() -> Font {
        return font(style: .button, size: 17).weight(.bold)
    }
}

extension View {
    public func appFont(style: AppTypography.TextStyle) -> some View {
        let font: Font
        switch style {
        case .headline:
            font = AppTypography.headline()
        case .subheadline:
            font = AppTypography.subheadline()
        case .body:
            font = AppTypography.body()
        case .caption:
            font = AppTypography.caption()
        case .button:
            font = AppTypography.button()
        }
        return self.font(font)
    }
}
