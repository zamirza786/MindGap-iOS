import SwiftUI
import SwiftData

struct JournalEntryEditorView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: JournalEntryEditorViewModel

    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            TextField("Title", text: $viewModel.title)
                .appFont(style: .headline)
                .padding(.horizontal)
                .textFieldStyle(.plain)

            TextEditor(text: $viewModel.body)
                .appFont(style: .body)
                .frame(minHeight: 200)
                .padding(AppSpacing.small)
                .background(AppColors.card)
                .cornerRadius(AppSpacing.medium)
                .appShadow(.small)

            // Mood Tag Selector (Placeholder)
            HStack {
                Text("Mood Tag:")
                    .appFont(style: .body)
                Picker("Mood", selection: $viewModel.moodTag) {
                    Text("None").tag(String?.none)
                    ForEach(MoodType.allCases, id: \.self) { moodType in
                        Text(moodType.rawValue).tag(moodType.rawValue as String?)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding(.horizontal)

            Button("Save Entry") {
                viewModel.save()
                dismiss()
            }
            .buttonStyle(AppButtonStyle(style: .primary))
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(AppColors.background)
        .navigationTitle(viewModel.title.isEmpty ? "New Entry" : viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct JournalEntryEditorView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: JournalEntry.self, configurations: config)
        
        let sampleEntry = JournalEntry(title: "Existing Entry", body: "This is an existing journal entry that is being edited.", date: Date(), moodTag: "Happy")
        container.mainContext.insert(sampleEntry)

        return Group {
            JournalEntryEditorView(viewModel: JournalEntryEditorViewModel(modelContext: container.mainContext))
                .previewDisplayName("New Entry")
            JournalEntryEditorView(viewModel: JournalEntryEditorViewModel(modelContext: container.mainContext, entry: sampleEntry))
                .previewDisplayName("Edit Entry")
        }
        .environmentObject(ThemeManager())
    }
}
