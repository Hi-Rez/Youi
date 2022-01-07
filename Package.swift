// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Youi",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [.library(name: "Youi", targets: ["Youi"])],
    dependencies: [.package(url: "https://github.com/Hi-Rez/Satin", .branch("master"))],
    targets: [.target(name: "Youi", dependencies: ["Satin"], resources: [.process("../../Assets.xcassets")])],
    swiftLanguageVersions: [.v5]
)
