import SwiftUI

public class ThemeManager: ObservableObject {
    @Published public var colorScheme: ColorScheme = .light {
        didSet {
            // Update any other theme-dependent properties here
        }
    }
}
