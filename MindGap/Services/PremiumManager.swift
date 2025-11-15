import Foundation
import Combine

/// Manages the premium status of the user and gates access to premium features.
@MainActor
final class PremiumManager: ObservableObject {

    /// Publishes the user's premium status. Views can subscribe to this to show/hide features.
    @Published private(set) var isPremium: Bool = false
    
    /// A key to store the premium status in UserDefaults.
    private let premiumStatusKey = "isPremiumUser"

    init() {
        // Load the premium status from UserDefaults on initialization.
        self.isPremium = UserDefaults.standard.bool(forKey: premiumStatusKey)
        print("Premium status loaded: \(isPremium)")
    }

    /// Unlocks premium features and saves the status.
    func unlockPremium() {
        isPremium = true
        UserDefaults.standard.set(true, forKey: premiumStatusKey)
        print("Premium features unlocked.")
    }

    /// Locks premium features and updates the saved status.
    /// Useful for testing or subscription expiration scenarios.
    func lockPremium() {
        isPremium = false
        UserDefaults.standard.set(false, forKey: premiumStatusKey)
        print("Premium features locked.")
    }
}
