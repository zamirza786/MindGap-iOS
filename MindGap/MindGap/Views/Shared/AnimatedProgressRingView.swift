import SwiftUI

struct AnimatedProgressRingView: View {
    let progress: Double
    let thickness: CGFloat
    let width: CGFloat
    let gradient: Gradient
    
    @State private var animatedProgress: Double = 0.0

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(AppColors.shadow.opacity(0.1), lineWidth: thickness)

            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(gradient: gradient, center: .center, startAngle: .degrees(0), endAngle: .degrees(360)),
                    style: StrokeStyle(lineWidth: thickness, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // Start from the top
            
            // Text in the center
            Text("\(Int(animatedProgress * 100))%")
                .appFont(style: .title1)
                .animation(.none, value: animatedProgress) // Prevent text from animating weirdly
        }
        .frame(width: width, height: width)
        .onAppear {
            updateProgress()
        }
        .onChange(of: progress) { _ in
            updateProgress()
        }
    }
    
    private func updateProgress() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.5)) {
            animatedProgress = progress
        }
    }
}

struct AnimatedProgressRingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            AnimatedProgressRingView(
                progress: 0.75,
                thickness: 20,
                width: 200,
                gradient: AppColors.gradient(for: .high)
            )
            
            AnimatedProgressRingView(
                progress: 0.25,
                thickness: 15,
                width: 150,
                gradient: AppColors.gradient(for: .low)
            )
        }
        .padding()
        .background(AppColors.background)
    }
}

