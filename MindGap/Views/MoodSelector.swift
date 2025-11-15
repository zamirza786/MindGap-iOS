import SwiftUI

/// A view that allows the user to select their mood from a set of options.
struct MoodSelector: View {
    
    /// A binding to the currently selected mood in the parent view.
    @Binding var selectedMood: ReflectionEntry.Mood

    var body: some View {
        HStack(spacing: 20) {
            ForEach(ReflectionEntry.Mood.allCases) { mood in
                Button(action: {
                    selectedMood = mood
                }) {
                    VStack {
                        Text(mood.emoji)
                            .font(.largeTitle)
                            .scaleEffect(selectedMood == mood ? 1.2 : 1.0)
                            .animation(.spring(), value: selectedMood)
                        
                        Text(mood.rawValue)
                            .font(.caption)
                            .foregroundStyle(selectedMood == mood ? AppColors.accent : .secondary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var mood: ReflectionEntry.Mood = .neutral
        var body: some View {
            MoodSelector(selectedMood: $mood)
        }
    }
    return PreviewWrapper()
        .padding()
        .background(AppColors.background)
}