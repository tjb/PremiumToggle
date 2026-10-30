import Foundation
import PremiumToggle

/// A throwaway `UserDefaults` suite that's deleted when the test finishes.
final class TestDefaults: Sendable {
    let suiteName = "PremiumToggleTests.\(UUID().uuidString)"

    var storage: PremiumDebugOverride {
        PremiumDebugOverride(suiteName: suiteName)
    }

    deinit {
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
    }
}
