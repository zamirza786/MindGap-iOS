import Foundation

/// Extensions to make working with dates easier and more consistent.
extension Date {
    
    /// Formats the date as a string, e.g., "November 14, 2025".
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    /// Formats the date as a short day and month, e.g., "Nov 14".
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
}