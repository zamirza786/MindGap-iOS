import SwiftUI

public struct AppIcon: View {
    let name: String
    let size: CGFloat

    public init(_ name: String, size: CGFloat = 24) {
        self.name = name
        self.size = size
    }

    public var body: some View {
        Image(systemName: name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
    }
}
