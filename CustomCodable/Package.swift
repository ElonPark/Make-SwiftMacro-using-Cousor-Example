// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "CustomCodable",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "CustomCodable",
      targets: ["CustomCodable"]
    ),
    .executable(
      name: "CustomCodableClient",
      targets: ["CustomCodableClient"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax", "509.0.0"..<"600.0.0-prerelease"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    // Macro implementation that performs the source transformation of a macro.
    .macro(
      name: "CustomCodableMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ]
    ),

    // Library that exposes a macro as part of its API, which is used in client programs.
    .target(name: "CustomCodable", dependencies: ["CustomCodableMacros"]),

    // A client of the library, which is able to use the macro in its own code.
    .executableTarget(name: "CustomCodableClient", dependencies: ["CustomCodable"]),

    // A test target used to develop the macro implementation.
    .testTarget(
      name: "CustomCodableTests",
      dependencies: [
        "CustomCodableMacros",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
  ]
)
