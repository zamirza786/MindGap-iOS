import SwiftUI

/// A view that displays a brief, temporary message overlay.
struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.headline)
            .padding()
            .background(.ultraThinMaterial, in: Capsule())
            .foregroundStyle(.primary)
            .shadow(radius: 10)
            .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
}

/// A view modifier to attach a toast view.
extension View {
    func toast(isShowing: Binding<Bool>, message: String, duration: TimeInterval = 2) -> some View {
        self.modifier(ToastModifier(isShowing: isShowing, message: message, duration: duration))
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let duration: TimeInterval

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            if isShowing {
                ToastView(message: message)
                    .onAppear {
                        // Schedule the toast to disappear after the duration.
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var showToast = false
        var body: some View {
            VStack {
                Button("Show Toast") {
                    withAnimation {
                        showToast = true
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
            .toast(isShowing: $showToast, message: "Reflection Saved!")
        }
    }
    return PreviewWrapper()
}