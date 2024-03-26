// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TBAUtil",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TBAUtil",
            targets: ["TBAUtil"]),
    ],
    dependencies: [.package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0"),
                   .package(url: "https://github.com/yj9294/gadutil.git", branch: "main"),
                   .package(url: "https://github.com/ashleymills/Reachability.swift.git", branch: "master")],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TBAUtil",
            dependencies: [.product(name: "Alamofire", package: "Alamofire"),
                           .product(name: "Reachability", package: "Reachability.swift"),
                           .product(name: "GADUtil", package: "GADUtil")]),
        .testTarget(
            name: "TBAUtilTests",
            dependencies: ["TBAUtil"]),
    ]
)
