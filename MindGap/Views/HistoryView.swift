import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var viewModel: JournalViewModel

    init() {
        _viewModel = StateObject(wrappedValue: JournalViewModel(dataManager: DataManager.shared))
    }

    var body: some View {
        List {
            if viewModel.reflections.isEmpty {
                emptyStateView
            } else {
                ForEach(viewModel.sortedMonthKeys, id: \.self) { monthKey in
                    Section(header: Text(monthKey)) {
                        ForEach(viewModel.groupedReflections[monthKey] ?? []) { entry in
                            entryRow(for: entry)
                        }
                    }
                }
            }
        }
        .navigationTitle("History")
        .listStyle(.insetGrouped)
        .background(AppColors.background.ignoresSafeArea())
    }

    private var emptyStateView: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("No Reflections Yet")
                .font(.headline)
            Text("Your past reflections will appear here once you save them.")
                .font(.subheadline)
                .foregroundStyle(AppColors.secondaryText)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func entryRow(for entry: ReflectionEntry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.date.shortDate)
                    .font(.headline)
                Spacer()
                Text(entry.mood.emoji)
                    .font(.title3)
            }
            
            Text(entry.question)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(entry.answer)
                .font(.body)
                .foregroundStyle(AppColors.secondaryText)
                .lineLimit(2)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HistoryView()
        .environmentObject(DataManager.shared)
}