import Observation

/// A type that reports premium status and accepts a debug override.
///
/// Conform your existing premium manager and mark it `@Observable` so the
/// debug panel updates when `isPremium` changes.
///
/// After `setDebugOverride(v)`, a conformer should report `debugOverride == v`
/// and `isPremium == v ?? realStatus`. A conformer whose
/// ``allowsDebugOverride`` is `false` ignores the call.
@MainActor
public protocol PremiumStatusProvider: AnyObject, Observable {
    /// Whether premium features are unlocked, including any debug override.
    var isPremium: Bool { get }

    /// The active debug override, or `nil` when real status is in effect.
    var debugOverride: Bool? { get }

    /// Whether this provider currently accepts debug overrides.
    ///
    /// The debug panel disables its controls when this is `false`. Defaults to
    /// `true`; return `PremiumToggleBuild.isDebug` (or your own flag) to block
    /// overrides in Release builds.
    var allowsDebugOverride: Bool { get }

    /// Forces premium on or off, or clears the override when `nil`.
    func setDebugOverride(_ value: Bool?)
}

public extension PremiumStatusProvider {
    var allowsDebugOverride: Bool { true }
}
