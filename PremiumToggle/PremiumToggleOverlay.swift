import SwiftUI

/// Build information used for safe defaults.
public enum PremiumToggleBuild {
    /// `true` when this package was compiled with the `DEBUG` flag.
    ///
    /// Swift packages follow the app's Debug/Release configuration, but custom
    /// configurations (Staging, QA) build packages as Release. Pass an explicit
    /// `isEnabled` to `premiumToggle(_:alignment:isEnabled:)` to show the panel there.
    public static let isDebug: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()
}

/// A floating ladybug button that opens a panel for overriding premium status.
///
/// Most apps attach it with ``SwiftUICore/View/premiumToggle(_:alignment:isEnabled:)``.
public struct PremiumToggleOverlay<Provider: PremiumStatusProvider>: View {
    private let provider: Provider
    @State private var isPanelPresented = false

    /// Creates the button for the given provider.
    public init(provider: Provider) {
        self.provider = provider
    }

    public var body: some View {
        Button {
            isPanelPresented.toggle()
        } label: {
            Label("Premium Debug Panel", systemImage: "ladybug.fill")
                .labelStyle(.iconOnly)
                .font(.title2)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .controlSize(.large)
        .tint(.red)
        .accessibilityValue(provider.isPremium ? "Premium on" : "Premium off")
        .accessibilityIdentifier("premiumToggle.button")
        .popover(isPresented: $isPanelPresented) {
            PremiumDebugPanel(provider: provider)
                .presentationCompactAdaptation(.popover)
        }
    }
}

struct PremiumDebugPanel<Provider: PremiumStatusProvider>: View {
    let provider: Provider

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Debug Panel")
                .font(.headline)

            Toggle("Premium", isOn: Binding(
                get: { provider.isPremium },
                set: { provider.setDebugOverride($0) }
            ))
            .accessibilityIdentifier("premiumToggle.toggle")

            status
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityElement(children: .combine)

            Button {
                provider.setDebugOverride(nil)
            } label: {
                Text("Use Real Status")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .buttonStyle(.glass)
            .disabled(provider.debugOverride == nil)
            .accessibilityIdentifier("premiumToggle.reset")
        }
        .disabled(!provider.allowsDebugOverride)
        .padding()
        .frame(minWidth: 240)
        // Popovers can't scroll, so keep the largest sizes from clipping the controls.
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }

    @ViewBuilder
    private var status: some View {
        if !provider.allowsDebugOverride {
            Label("Overrides disabled in this build", systemImage: "lock")
                .foregroundStyle(.secondary)
        } else if provider.debugOverride == nil {
            Label("Using real status", systemImage: "checkmark.seal")
                .foregroundStyle(.secondary)
        } else {
            Label("Debug override active", systemImage: "wrench.and.screwdriver")
                .foregroundStyle(.orange)
        }
    }
}

public extension View {
    /// Overlays a ``PremiumToggleOverlay`` button for overriding premium status.
    ///
    /// - Parameters:
    ///   - provider: The premium manager the panel controls.
    ///   - alignment: Where the button sits. Defaults to the bottom-trailing corner.
    ///     In a `TabView` app, attach it inside a tab or pick another alignment so
    ///     it doesn't cover the tab bar.
    ///   - isEnabled: Whether to show the button. Defaults to Debug builds only.
    func premiumToggle(
        _ provider: some PremiumStatusProvider,
        alignment: Alignment = .bottomTrailing,
        isEnabled: Bool = PremiumToggleBuild.isDebug
    ) -> some View {
        overlay(alignment: alignment) {
            if isEnabled {
                PremiumToggleOverlay(provider: provider)
                    .padding()
            }
        }
    }
}
