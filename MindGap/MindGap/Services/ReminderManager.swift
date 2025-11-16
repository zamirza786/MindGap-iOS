import Foundation
import UserNotifications

class ReminderManager {
    static let shared = ReminderManager()
    private init() {}

    private let reminderTitle = "MindGap Reminder"
    private let reminderBody = "Take a moment to reflect and check in with yourself today."
    private let reminderIdentifier = "dailyMindGapReminder"

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    func scheduleDailyReminder(at time: Date) {
        cancelAllReminders() // Cancel any existing reminders first

        let content = UNMutableNotificationContent()
        content.title = reminderTitle
        content.body = reminderBody
        content.sound = .default

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        dateComponents.second = 0 // Ensure it fires at the exact minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: reminderIdentifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling reminder: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled for \(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0)")
            }
        }
    }

    func cancelAllReminders() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
        print("All MindGap reminders cancelled.")
    }
    
    func getPendingReminderStatus(completion: @escaping (Bool, Date?) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            if let reminderRequest = requests.first(where: { $0.identifier == self.reminderIdentifier }),
               let trigger = reminderRequest.trigger as? UNCalendarNotificationTrigger,
               let hour = trigger.dateComponents.hour,
               let minute = trigger.dateComponents.minute {
                
                var currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                currentDateComponents.hour = hour
                currentDateComponents.minute = minute
                let scheduledTime = Calendar.current.date(from: currentDateComponents)
                completion(true, scheduledTime)
            } else {
                completion(false, nil)
            }
        }
    }
}
