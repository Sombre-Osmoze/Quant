// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Quant",
  platforms: [
    .macOS(.v13),
    .iOS(.v16),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    .library(name: "Quant", targets: ["Quant"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "Quant",
      dependencies: [
        .product(name: "Algorithms", package: "swift-algorithms"),
        .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
      ]
    ),
    .testTarget(
      name: "QuantTests",
      dependencies: ["Quant"]
    ),
  ]
)
