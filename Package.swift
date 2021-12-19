// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "YeeLampa",
	platforms: [
		.iOS(.v13),
		.macOS(.v12)
	],
	products: [
		.library(
			name: "YeeLampa",
			targets: ["YeeLampa"]),
	],
	dependencies: [
		.package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0"))
	],
	targets: [
		.target(
			name: "YeeLampa",
			dependencies: ["Alamofire"],
			resources: [
				.copy("Resources/DeviceProps.plist")
			]
		),
//		.testTarget(
//			name: "YeeLampaTests",
//			dependencies: ["YeeLampa"]),
	]
)
