import Foundation

/// Persists a premium debug override in `UserDefaults` so it survives relaunches.
///
/// It does no build gating itself. Check your provider's `allowsDebugOverride`
/// before reading or writing it:
///
/// ```swift
/// private let storage = PremiumDebugOverride()
///
/// func setDebugOverride(_ value: Bool?) {
///     guard allowsDebugOverride else { return }
///     storage.value = value
///     debugOverride = value
/// }
/// ```
public struct PremiumDebugOverride: Sendable {
    /// The key used when none is given.
    public static let defaultKey = "debug_premium_override"

    private let suiteName: String?
    /// The `UserDefaults` key the override is stored under.
    public let key: String

    /// - Parameters:
    ///   - suiteName: A `UserDefaults` suite, or `nil` for `.standard`.
    ///   - key: The key the override is stored under.
    public init(suiteName: String? = nil, key: String = defaultKey) {
        self.suiteName = suiteName
        self.key = key
    }

    private var defaults: UserDefaults {
        suiteName.flatMap(UserDefaults.init(suiteName:)) ?? .standard
    }

    /// The stored override, or `nil` when none is set. Setting `nil` removes it.
    public var value: Bool? {
        get { defaults.object(forKey: key) as? Bool }
        nonmutating set {
            if let newValue {
                defaults.set(newValue, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
