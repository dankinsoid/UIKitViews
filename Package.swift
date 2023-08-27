// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "UIKitViews",
	platforms: [
		.iOS(.v13),
	],
	products: [
		.library(name: "UIKitViews", targets: ["UIKitViews"]),
	],
	dependencies: [
		.package(url: "https://github.com/dankinsoid/VDChain.git", from: "3.6.0"),
	],
	targets: [
		.target(
			name: "UIKitViews",
			dependencies: [
				"VDChain",
			]
		),
	]
)
