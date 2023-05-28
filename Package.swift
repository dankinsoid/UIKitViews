// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "UIKitView",
	platforms: [
		.iOS(.v13),
	],
	products: [
		.library(name: "UIKitView", targets: ["UIKitView"]),
	],
	dependencies: [
		.package(url: "https://github.com/dankinsoid/VDChain.git", from: "2.7.3"),
	],
	targets: [
		.target(
			name: "UIKitView",
			dependencies: [
				"VDChain",
			]
		),
	]
)
