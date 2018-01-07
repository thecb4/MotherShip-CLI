// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MotherShip-CLI",
  dependencies: [
      // Dependencies declare other packages that this package depends on.
      // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "git@github.com:thecb4/MotherShip.git", .branch("master")),
    .package(url: "git@github.com:thecb4/HyperSpace.git", .branch("master")),
    .package(url: "https://github.com/kylef/Commander.git", .upToNextMinor(from:"0.8.0")),
    .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .branch("master")),
    .package(url: "https://github.com/JohnSundell/Files.git",.branch("master"))
    
  ],
  targets: [
      // Targets are the basic building blocks of a package. A target can define a module or a test suite.
      // Targets can depend on other targets in this package, and on products in packages which this package depends on.
      .target(
          name: "MotherShip-CLI",
          dependencies: ["MotherShip","HyperSpace", "Commander","CryptoSwift", "Files" ]),
  ]
)
