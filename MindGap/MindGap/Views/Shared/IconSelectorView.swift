import SwiftUI

struct IconSelectorView: View {
    @Binding var selectedIcon: String
    let icons: [String] = [
        "star.fill", "heart.fill", "flag.fill", "book.closed.fill", "briefcase.fill",
        "graduationcap.fill", "dumbbell.fill", "leaf.fill", "lightbulb.fill", "pencil.and.outline",
        "cart.fill", "house.fill", "car.fill", "airplane", "gamecontroller.fill",
        "camera.fill", "music.note", "paintpalette.fill", "globe.americas.fill", "sparkles"
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.medium) {
                ForEach(icons, id: \.self) { iconName in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            selectedIcon = iconName
                        }
                    } label: {
                        Image(systemName: iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(selectedIcon == iconName ? AppColors.background : AppColors.text)
                            .padding(AppSpacing.small)
                            .background(
                                Circle()
                                    .fill(selectedIcon == iconName ? AppColors.accent : AppColors.card)
                                    .appShadow(selectedIcon == iconName ? .medium : .small)
                            )
                            .scaleEffect(selectedIcon == iconName ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedIcon == iconName)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct IconSelectorView_Previews: PreviewProvider {
    @State static var selectedIcon: String = "star.fill"
    static var previews: some View {
        IconSelectorView(selectedIcon: $selectedIcon)
            .environmentObject(ThemeManager())
    }
}
