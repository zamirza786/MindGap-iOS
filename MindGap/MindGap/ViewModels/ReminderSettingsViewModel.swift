import Foundation
import Combine
import SwiftUI

class ReminderSettingsViewModel: ObservableObject {
    @AppStorage("isReminderEnabled") var isReminderEnabled: Bool = false {
        didSet {
            updateReminderStatus()
        }
    }
    @AppStorage("reminderTime") var reminderTimeData: Data? {
        didSet {
            if let data = reminderTimeData, let date = try? JSONDecoder().decode(Date.self, from: data) {
                reminderTime = date
            }
            updateReminderStatus()
        }
    }

    @Published var reminderTime: Date = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date()

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadSavedSettings()
        $reminderTime
            .dropFirst() // Don't trigger on initial load
            .sink { [weak self] newTime in
                self?.reminderTimeData = try? JSONEncoder().encode(newTime)
                self?.updateReminderStatus()
            }
            .store(in: &cancellables)
    }

    func loadSavedSettings() {
        if let data = reminderTimeData, let date = try? JSONDecoder().decode(Date.self, from: data) {
            reminderTime = date
        }
        // Ensure the reminder status is consistent with the AppStorage value
        updateReminderStatus()
    }

    func toggleReminder() {
        isReminderEnabled.toggle()
    }

    private func updateReminderStatus() {
        if isReminderEnabled {
            ReminderManager.shared.scheduleDailyReminder(at: reminderTime)
        } else {
            ReminderManager.shared.cancelAllReminders()
        }
    }
    
    func requestNotificationPermission() {
        ReminderManager.shared.requestPermission()
    }
}
