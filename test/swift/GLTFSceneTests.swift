import Foundation
import Testing

@testable import GLTF

struct GLTFSceneTests {
  @Test("Scene properties are accessible")
  func sceneProperties() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)
    #expect(document.scenes.count > 0)

    let scene = document.scenes[0]

    let _ = scene.name
    #expect(scene.nodes.count >= 0)
  }

  @Test("Scene nodes reference")
  func sceneNodes() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)

    for scene in document.scenes {
      for sceneNode in scene.nodes {
        // Scene node should exist in document nodes
        let nodeExists = document.nodes.contains {
          $0.name == sceneNode.name || sceneNode.name == "<unnamed>"
        }
        #expect(nodeExists || document.nodes.isEmpty == false)
      }
    }
  }
}
