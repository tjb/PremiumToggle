import Foundation
import Observation
import PremiumToggle

@MainActor
@Observable
final class DemoPremiumManager: PremiumStatusProvider {
    // The demo has no real purchases, so real status is always free.
    var isPremium: Bool { debugOverride ?? false }
    private(set) var debugOverride: Bool?

    let allowsDebugOverride = PremiumToggleBuild.isDebug
    private let storage = PremiumDebugOverride()

    init() {
        if allowsDebugOverride {
            debugOverride = storage.value
        }
    }

    func setDebugOverride(_ value: Bool?) {
        guard allowsDebugOverride else { return }
        storage.value = value
        debugOverride = value
    }
}
