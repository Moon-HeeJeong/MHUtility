// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MHUtility",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MHOrientation",
            targets: ["MHOrientation"]),
        .library(
            name: "MHExtension",
            targets: ["MHExtension"]),
        .library(
            name: "MHAPI",
            targets: ["MHAPI"]),
        .library(
            name: "MHDevice",
            targets: ["MHDevice"]),
        .library(
            name: "MHDownloader",
            targets: ["MHDownloader"]),
        .library(
            name: "MHImageCache",
            targets: ["MHImageCache"]),
        .library(
            name: "MHLog",
            targets: ["MHLog"]),
        .library(
            name: "MHTextFieldListView",
            targets: ["MHTextFieldListView"]),
        .library(
            name: "MHUIUtility",
            targets: ["MHUIUtility"]),
        .library(
            name: "MHUserDefaults",
            targets: ["MHUserDefaults"]),
        .library(
            name: "MHNavigation",
            targets: ["MHNavigation"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.5.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MHOrientation",
            dependencies: [],
        path: "Targets/MHOrientation/Sources"),
        .testTarget(
            name: "MHOrientationTests",
            dependencies: ["MHOrientation"],
        path: "Targets/MHOrientation/Tests"),
        .target(
            name: "MHExtension",
            dependencies: [],
            path: "Targets/MHExtension/Sources"),
        .testTarget(
            name: "MHExtensionTests",
            dependencies: ["MHExtension"],
            path: "Targets/MHExtension/Tests"),
        .target(
            name: "MHAPI",
            dependencies: [],
            path: "Targets/MHAPI/Sources"),
        .testTarget(
            name: "MHAPITests",
            dependencies: ["MHAPI"],
            path: "Targets/MHAPI/Tests"),
        .target(
            name: "MHDevice",
            dependencies: [],
            path: "Targets/MHDevice/Sources"),
        .testTarget(
            name: "MHDeviceTests",
            dependencies: ["MHDevice"],
            path: "Targets/MHDevice/Tests"),
        .target(
            name: "MHDownloader",
            dependencies: [],
            path: "Targets/MHDownloader/Sources"),
        .testTarget(
            name: "MHDownloaderTests",
            dependencies: ["MHDownloader"],
            path: "Targets/MHDownloader/Tests"),
        .target(
            name: "MHImageCache",
            dependencies: [],
            path: "Targets/MHImageCache/Sources"),
        .testTarget(
            name: "MHImageCacheTests",
            dependencies: ["MHImageCache"],
            path: "Targets/MHImageCache/Tests"),
        .target(
            name: "MHLog",
            dependencies: [],
            path: "Targets/MHLog/Sources"),
        .testTarget(
            name: "MHLogTests",
            dependencies: ["MHLog"],
            path: "Targets/MHLog/Tests"),
        .target(
            name: "MHTextFieldListView",
            dependencies: ["RxSwift"],
            path: "Targets/MHTextFieldListView/Sources"),
        .testTarget(
            name: "MHTextFieldListViewTests",
            dependencies: ["MHTextFieldListView"],
            path: "Targets/MHTextFieldListView/Tests"),
        .target(
            name: "MHUIUtility",
            dependencies: [],
            path: "Targets/MHUIUtility/Sources"),
        .testTarget(
            name: "MHUIUtilityTests",
            dependencies: ["MHUIUtility"],
            path: "Targets/MHUIUtility/Tests"),
        .target(
            name: "MHUserDefaults",
            dependencies: [],
            path: "Targets/MHUserDefaults/Sources"),
        .testTarget(
            name: "MHUserDefaultsTests",
            dependencies: ["MHUserDefaults"],
            path: "Targets/MHUserDefaults/Tests"),
        .target(
            name: "MHNavigation",
            dependencies: [],
            path: "Targets/MHNavigation/Sources"),
        .testTarget(
            name: "MHNavigationTests",
            dependencies: ["MHNavigation"],
            path: "Targets/MHNavigation/Tests"),
    ]
)
