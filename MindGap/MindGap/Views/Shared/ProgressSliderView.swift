import SwiftUI

struct ProgressSliderView: View {
    @Binding var progress: Double
    var tintColor: Color = AppColors.accent // Default tint color

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Progress: \(Int(progress * 100))%")
                .appFont(style: .body)
                .foregroundColor(AppColors.text)
            
            Slider(value: $progress, in: 0...1, step: 0.01)
                .tint(tintColor)
        }
        .padding(AppSpacing.medium)
        .background(AppColors.card)
        .cornerRadius(AppSpacing.medium)
        .appShadow(.small)
    }
}

struct ProgressSliderView_Previews: PreviewProvider {
    @State static var progress: Double = 0.5
    static var previews: some View {
        ProgressSliderView(progress: $progress)
            .environmentObject(ThemeManager())
    }
}
