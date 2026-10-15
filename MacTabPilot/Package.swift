// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Bulltab",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "Bulltab",
            targets: ["MacTabPilotApp"]
        ),
        .executable(
            name: "MacTabPilotTestRunner",
            targets: ["MacTabPilotTestRunner"]
        ),
        .library(
            name: "MacTabPilotCore",
            targets: ["MacTabPilotCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MacTabPilotCore",
            dependencies: [],
            path: "Sources/MacTabPilotCore"
        ),
        .executableTarget(
            name: "MacTabPilotApp",
            dependencies: ["MacTabPilotCore"],
            path: "Sources/MacTabPilotApp"
        ),
        .executableTarget(
            name: "MacTabPilotTestRunner",
            dependencies: ["MacTabPilotCore"],
            path: "Sources/MacTabPilotTestRunner"
        )
    ]
)
