import Foundation
import Observation
import Testing
import PremiumToggle

/// The provider pattern from the README.
@MainActor
@Observable
private final class SampleManager: PremiumStatusProvider {
    var isPremium: Bool { debugOverride ?? isEntitled }
    private(set) var debugOverride: Bool?
    var isEntitled = false

    let allowsDebugOverride: Bool
    private let overrideStorage: PremiumDebugOverride

    init(allowsDebugOverride: Bool = true, overrideStorage: PremiumDebugOverride) {
        self.allowsDebugOverride = allowsDebugOverride
        self.overrideStorage = overrideStorage
        if allowsDebugOverride {
            debugOverride = overrideStorage.value
        }
    }

    func setDebugOverride(_ value: Bool?) {
        guard allowsDebugOverride else { return }
        overrideStorage.value = value
        debugOverride = value
    }
}

@MainActor
private final class MinimalProvider: PremiumStatusProvider {
    var isPremium = false
    var debugOverride: Bool?
    func setDebugOverride(_ value: Bool?) { debugOverride = value }
}

@MainActor
struct DebugOverrideTests {
    private let defaults = TestDefaults()
    private var storage: PremiumDebugOverride { defaults.storage }

    @Test func storageRoundTrips() {
        #expect(storage.value == nil)
        storage.value = true
        #expect(storage.value == true)
        storage.value = false
        #expect(storage.value == false)
        storage.value = nil
        #expect(storage.value == nil)
    }

    @Test func storageUsesDefaultKey() {
        storage.value = true
        let raw = UserDefaults(suiteName: defaults.suiteName)?.object(forKey: PremiumDebugOverride.defaultKey)
        #expect(raw as? Bool == true)
    }

    @Test func storageKeysAreIndependent() {
        let other = PremiumDebugOverride(suiteName: defaults.suiteName, key: "other_key")
        storage.value = true
        #expect(other.value == nil)
        other.value = false
        #expect(storage.value == true)
    }

    @Test func managerAppliesAndPersistsOverride() {
        let manager = SampleManager(overrideStorage: storage)
        manager.setDebugOverride(true)
        #expect(manager.isPremium)
        #expect(storage.value == true)

        let relaunched = SampleManager(overrideStorage: storage)
        #expect(relaunched.isPremium)
        #expect(relaunched.debugOverride == true)
    }

    @Test func forcingOffOverridesEntitlement() {
        let manager = SampleManager(overrideStorage: storage)
        manager.isEntitled = true
        manager.setDebugOverride(false)
        #expect(!manager.isPremium)
        #expect(storage.value == false)
    }

    @Test func storedFalseOverrideSurvivesRelaunch() {
        storage.value = false
        let manager = SampleManager(overrideStorage: storage)
        manager.isEntitled = true
        #expect(manager.debugOverride == false)
        #expect(!manager.isPremium)
    }

    @Test func clearingRestoresRealStatus() {
        let manager = SampleManager(overrideStorage: storage)
        manager.isEntitled = true
        manager.setDebugOverride(false)
        manager.setDebugOverride(nil)
        #expect(manager.debugOverride == nil)
        #expect(storage.value == nil)
        #expect(manager.isPremium)
    }

    @Test func overrideIgnoredWhenDisallowed() {
        storage.value = true
        let manager = SampleManager(allowsDebugOverride: false, overrideStorage: storage)
        #expect(!manager.isPremium)
        #expect(manager.debugOverride == nil)

        manager.setDebugOverride(true)
        #expect(!manager.isPremium)
        #expect(storage.value == true)
    }

    @Test func allowsDebugOverrideDefaultsToTrue() {
        #expect(MinimalProvider().allowsDebugOverride)
    }

    @Test func testsBuildInDebug() {
        #expect(PremiumToggleBuild.isDebug)
    }
}
