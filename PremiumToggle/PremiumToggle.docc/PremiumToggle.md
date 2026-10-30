# ``PremiumToggle``

A SwiftUI debug overlay for toggling premium state during development.

## Overview

PremiumToggle adds a floating ladybug button to your app. Tapping it opens a
panel where you can force premium on or off, or go back to your real status,
without making test purchases.

Conform your premium manager to ``PremiumStatusProvider`` and attach the
overlay at your app's root:

```swift
@main
struct MyApp: App {
    @State private var premiumManager = MyPremiumManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(premiumManager)
                .premiumToggle(premiumManager)
        }
    }
}
```

The button only appears in Debug builds by default. Gate overrides in your
provider with ``PremiumStatusProvider/allowsDebugOverride``, which defaults to
`true`, so a leftover override can't unlock premium in production. Return
``PremiumToggleBuild/isDebug`` from it, or your own flag for QA and TestFlight
builds, and pass the same flag as `isEnabled:`.

## Topics

### Essentials

- ``PremiumStatusProvider``
- ``SwiftUICore/View/premiumToggle(_:alignment:isEnabled:)``
- ``PremiumToggleOverlay``

### Storing overrides

- ``PremiumDebugOverride``
- ``PremiumToggleBuild``
