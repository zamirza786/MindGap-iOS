import SwiftUI
import SwiftData

struct JournalHomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = JournalHomeViewModel(modelContext: {
        // Provide a dummy ModelContext for initial StateObject creation.
        // This will be replaced by the environment's modelContext in .onAppear.
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: JournalEntry.self, configurations: config)
        return ModelContext(container)
    }())

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.entries) { entry in
                    NavigationLink(destination: JournalEntryEditorView(viewModel: JournalEntryEditorViewModel(modelContext: modelContext, entry: entry))) {
                        JournalEntryRow(entry: entry)
                    }
                }
                .onDelete(perform: viewModel.deleteEntry)
            }
            .navigationTitle("Your Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: JournalEntryEditorView(viewModel: JournalEntryEditorViewModel(modelContext: modelContext))) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.modelContext = modelContext // Update viewModel with the actual environment modelContext
                viewModel.fetchEntries()
            }
        }
    }
}

struct JournalEntryRow: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(entry.title)
                .appFont(style: .subheadline)
            Text(entry.body)
                .appFont(style: .body)
                .lineLimit(2)
            Text(entry.date, style: .date)
                .appFont(style: .caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.vertical, AppSpacing.small)
    }
}

struct JournalHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: JournalEntry.self, configurations: config)
        
        // Add sample data
        let sampleEntry = JournalEntry(title: "Sample Title", body: "This is a sample journal entry.", date: Date())
        container.mainContext.insert(sampleEntry)
        
        return JournalHomeView()
            .environmentObject(ThemeManager())
            .modelContainer(container)
    }
}
