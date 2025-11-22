import SwiftUI

struct ColorSelectorView: View {
    @Binding var selectedColorHex: String
    
    let themeColors: [Color] = [
        Color(hex: "#4285F4"), // Google Blue
        Color(hex: "#DB4437"), // Google Red
        Color(hex: "#F4B400"), // Google Yellow
        Color(hex: "#0F9D58"), // Google Green
        Color(hex: "#673AB7"), // Deep Purple
        Color(hex: "#E91E63"), // Pink
        Color(hex: "#00BCD4")  // Cyan
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.medium) {
                ForEach(themeColors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(selectedColorHex == color.toHex() ? AppColors.accent : Color.clear, lineWidth: 3)
                                .scaleEffect(selectedColorHex == color.toHex() ? 1.2 : 1.0)
                                .opacity(selectedColorHex == color.toHex() ? 1 : 0)
                        )
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedColorHex == color.toHex())
                        .onTapGesture {
                            selectedColorHex = color.toHex()
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ColorSelectorView_Previews: PreviewProvider {
    @State static var selectedColor: String = Color(hex: "#4285F4").toHex()
    static var previews: some View {
        ColorSelectorView(selectedColorHex: $selectedColor)
            .environmentObject(ThemeManager())
    }
}
