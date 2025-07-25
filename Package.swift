// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sussmods_bot",
    products: [
        .executable(name:"sussmods_bot", targets:["sussmods_bot"])
    ],
    dependencies: [
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.15.4"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-testing.git", branch: "main")
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "sussmods_bot",
            dependencies:[
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SQLite", package: "sqlite.swift")
            ]),
        .testTarget(
            name: "sussmods_bot_tests",
            dependencies:[
                "sussmods_bot",
                .product(name: "Testing", package: "swift-testing")
            ],
            exclude: [
                "bad0.json", "bad1.json", "bad2.json", "bad3.json", "bad4.json", "bad5.json",
                "good0.json", "good1.json", "good2.json", "empty.json"
            ]),
        
    ]
)
