// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Youi",
    platforms: [.macOS(.v10_15), .iOS(.v14)],
    products: [.library(name: "Youi", targets: ["Youi"])],
    dependencies: [.package(url: "https://github.com/Hi-Rez/Satin", from: "1.6.1")],
    targets: [.target(name: "Youi", dependencies: ["Satin"], resources: [.process("Resources")])],
    swiftLanguageVersions: [.v5]
)
