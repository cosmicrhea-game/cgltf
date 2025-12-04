// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "cgltf",
  platforms: [
    .macOS(.v11)
  ],
  products: [
    .library(name: "GLTF", targets: ["GLTF"])
  ],
  targets: [
    .target(name: "GLTF", dependencies: ["CGLTF"], path: "swift"),
    .target(name: "CGLTF", path: ".", sources: ["cgltf.h", "cgltf.c"]),
    .testTarget(
      name: "GLTFTests",
      dependencies: ["GLTF"],
      path: "test/swift",
      resources: [
        .process("../../fuzz/data")
      ]
    ),
  ]
)
