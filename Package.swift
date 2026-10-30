// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "PremiumToggle",
    platforms: [
        .iOS(.v26),
        .macOS(.v26)
    ],
    products: [
        .library(
            name: "PremiumToggle",
            targets: ["PremiumToggle"]
        )
    ],
    targets: [
        .target(
            name: "PremiumToggle",
            path: "PremiumToggle",
            resources: [.copy("Resources/PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "PremiumToggleTests",
            dependencies: ["PremiumToggle"],
            path: "PremiumToggleTests"
        )
    ]
)
