import Foundation
import UserNotifications

/// A service to manage local notifications for daily reminders.
final class NotificationManager {

    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()

    private init() {}

    /// Requests authorization from the user to send notifications.
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
                self.scheduleDailyReminder()
            } else if let error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }

    /// Schedules a daily notification to remind the user to reflect.
    /// The default time is 8:00 PM (20:00).
    func scheduleDailyReminder(hour: Int = 20, minute: Int = 0) {
        let content = UNMutableNotificationContent()
        content.title = "MindGap Daily Reflection"
        content.body = "Time for your daily reflection. What's on your mind?"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Create a trigger that repeats daily at the specified time.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "MindGapDailyReminder", content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            if let error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled successfully for \(hour):\(String(format: "%02d", minute)).")
            }
        }
    }
    
    /// Cancels any pending daily reminders.
    func cancelNotifications() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["MindGapDailyReminder"])
        print("Cancelled all scheduled notifications.")
    }
}
