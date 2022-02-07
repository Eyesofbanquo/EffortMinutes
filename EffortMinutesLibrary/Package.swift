// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EffortMinutesLibrary",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EffortDesign",
            targets: ["EffortDesign"]),
        .library(name: "EffortPresentation",
                 targets: ["EffortPresentation"]),
        .library(name: "EffortModel",
                 targets: ["EffortModel"]),
        .library(name: "EMRankLadder",
                 targets: ["EMRankLadder"]),
        .library(name: "EMTimer", targets: ["EMTimer"]),
        .library(name: "EMAddCategory", targets: ["EMAddCategory"]),
        .library(name: "EMOnboarding", targets: ["EMOnboarding"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
      .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.0"),
      .package(url: "https://github.com/realm/realm-swift.git", from: "10.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "EffortDesign",
            dependencies: ["EffortModel",
                           "SnapKit"]),
        .target(name: "EffortPresentation",
                dependencies: ["SnapKit"]),
        .target(name: "EffortModel",
                dependencies: [.product(name: "RealmSwift", package: "realm-swift")]),
        /* Apps */
        .target(name: "EMRankLadder", dependencies: ["SnapKit",
                                                     "EffortModel",
                                                     "EffortPresentation",
                                                     "EffortDesign"]),
        .target(name: "EMTimer", dependencies: ["SnapKit", "EffortDesign"]),
        .target(name: "EMAddCategory", dependencies: ["SnapKit",
                                                      "EffortDesign",
                                                      "EffortPresentation",
                                                      .product(name: "RealmSwift", package: "realm-swift")], swiftSettings: [.define("FRAMEWORK", .when(platforms: [.iOS], configuration: .debug))]),
        .target(name: "EMOnboarding",
                dependencies: ["SnapKit", "EffortDesign"],
                swiftSettings: [.define("ONBOARDING_RESET", .when(platforms: [.iOS], configuration: .debug))]),
        .testTarget(
            name: "EffortDesignTests",
            dependencies: ["EffortDesign"]),
    ]
)
