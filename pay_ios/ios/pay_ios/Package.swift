// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "pay_ios",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "pay-ios", targets: ["pay_ios"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "pay_ios",
            dependencies: [],
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
