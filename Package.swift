// swift-tools-version: 6.2

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/10/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

/// Defines the settings library and its integration tests.
let package = Package(
  name: "Settings",

  platforms: [
    .macOS("26.0"), .iOS("26.0"), .tvOS("26.0"),
  ],

  products: [
    .library(
      name: "Settings",
      targets: ["Settings"]
    )
  ],

  dependencies: [
    .package(url: "https://github.com/elegantchaos/ChaosTesting.git", from: "1.1.0")
  ],

  targets: [
    .target(
      name: "Settings"
    ),
    .testTarget(
      name: "SettingsTests",
      dependencies: [
        "Settings",
        .product(name: "ChaosTesting", package: "ChaosTesting"),
      ]
    ),
  ]
)

for target in package.targets {
  switch target.type {
  case .regular, .test:
    var settings = target.swiftSettings ?? []
    settings.append(contentsOf: [
      .defaultIsolation(MainActor.self),
      .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
      .enableUpcomingFeature("InferIsolatedConformances"),
      .enableExperimentalFeature("SendableProhibitsMainActorInference"),
    ])
    target.swiftSettings = settings
  default:
    continue
  }

}
