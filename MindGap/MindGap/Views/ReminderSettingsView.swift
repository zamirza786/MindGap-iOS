import SwiftUI

struct ReminderSettingsView: View {
    @StateObject private var viewModel = ReminderSettingsViewModel()

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Toggle(isOn: $viewModel.isReminderEnabled) {
                Text("Daily Reminder")
                    .appFont(style: .body)
            }
            .padding(.horizontal)
            .onChange(of: viewModel.isReminderEnabled) { enabled in
                if enabled {
                    viewModel.requestNotificationPermission()
                }
            }

            if viewModel.isReminderEnabled {
                DatePicker(
                    "Reminder Time",
                    selection: $viewModel.reminderTime,
                    displayedComponents: .hourAndMinute
                )
                .appFont(style: .body)
                .padding(.horizontal)
                .labelsHidden() // Hide default label to use our own styling
                
                Text("Reminder set for \(viewModel.reminderTime, formatter: timeFormatter)")
                    .appFont(style: .caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(.vertical)
        .background(AppColors.background)
        .navigationTitle("Reminder Settings")
        .onAppear(perform: viewModel.loadSavedSettings)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct ReminderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReminderSettingsView()
        }
        .environmentObject(ThemeManager())
    }
}
