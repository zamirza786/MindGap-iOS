import SwiftUI

public enum AppTypography {
    public static func font(style: TextStyle, size: CGFloat) -> Font {
        return .system(size: size)
    }

    public enum TextStyle {
        case title1
        case headline
        case subheadline
        case body
        case caption
        case caption2
        case button
    }

    public static func title1() -> Font {
        return font(style: .title1, size: 34).weight(.bold)
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
    
    public static func caption2() -> Font {
        return font(style: .caption2, size: 10)
    }

    public static func button() -> Font {
        return font(style: .button, size: 17).weight(.bold)
    }
}

extension View {
    public func appFont(style: AppTypography.TextStyle) -> some View {
        let font: Font
        switch style {
        case .title1:
            font = AppTypography.title1()
        case .headline:
            font = AppTypography.headline()
        case .subheadline:
            font = AppTypography.subheadline()
        case .body:
            font = AppTypography.body()
        case .caption:
            font = AppTypography.caption()
        case .caption2:
            font = AppTypography.caption2()
        case .button:
            font = AppTypography.button()
        }
        return self.font(font)
    }
}
