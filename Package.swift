import PackageDescription

let package = Package(
    name: "FXSlider",
    platforms: [.iOS(.v8)],
    products: [
        .library(name: "FXSlider", targets: ["FXSlider"]),
    ],
    targets: [
        .target(
            name: "FXSlider",
            path: "FXSlider"
        )
    ]
)
