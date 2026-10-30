import SwiftUI

struct DemoContentView: View {
    @Environment(DemoPremiumManager.self) private var premiumManager

    var body: some View {
        NavigationStack {
            List {
                Section("Current State") {
                    HStack {
                        Text("Premium")
                        Spacer()
                        Text(premiumManager.isPremium ? "Enabled" : "Disabled")
                            .foregroundStyle(premiumManager.isPremium ? .green : .red)
                            .fontWeight(.semibold)
                    }
                }

                Section("Premium Feature") {
                    if premiumManager.isPremium {
                        Label("Unlocked in this session", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                    } else {
                        Label("Locked until premium is enabled", systemImage: "lock.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("PremiumToggle Demo")
        }
    }
}

#Preview {
    DemoContentView()
        .environment(DemoPremiumManager())
}

