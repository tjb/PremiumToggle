import SwiftUI
import PremiumToggle

@main
struct PremiumToggleDemoApp: App {
    @State private var premiumManager = DemoPremiumManager()

    var body: some Scene {
        WindowGroup {
            DemoContentView()
                .environment(premiumManager)
                .premiumToggle(premiumManager)
        }
    }
}
