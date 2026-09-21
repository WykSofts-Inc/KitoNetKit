// swift-tools-version: 5.9
//
//  Package.swift
//  KitoNetKit
//
//  Created by Wycliff on 9/19/26.
//  Copyright © 2026 wyksoftsinc.com. All rights reserved.
//


import PackageDescription

let package = Package(
    name: "KitoNetKit",
    platforms: [.iOS(.v17)],
    products: [.library(name: "KitoNetKit", targets: ["KitoNetKit"])],
    dependencies: [
        .package(url: "https://github.com/WykSofts-Inc/KitoCore.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "KitoNetKit", dependencies: [.product(name: "KitoCore", package: "KitoCore")]),
        .testTarget(name: "KitoNetKitTests", dependencies: ["KitoNetKit"]),
    ]
)
