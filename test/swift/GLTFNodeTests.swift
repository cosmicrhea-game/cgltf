import Foundation
import Testing

@testable import GLTF

struct GLTFNodeTests {
  @Test("Node properties are accessible")
  func nodeProperties() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)
    #expect(document.nodes.count > 0)

    let node = document.nodes[0]

    // Name should be accessible (even if empty)
    let _ = node.name

    // Optional properties should work
    let _ = node.parent
    let _ = node.children
    let _ = node.skin
    let _ = node.mesh
    let _ = node.camera
    let _ = node.light

    // Transform properties
    let _ = node.hasTranslation
    let _ = node.hasRotation
    let _ = node.hasScale
    let _ = node.hasMatrix

    if node.hasTranslation {
      let _ = node.translation
    }
    if node.hasRotation {
      let _ = node.rotation
    }
    if node.hasScale {
      let _ = node.scale
    }
    if node.hasMatrix {
      let _ = node.matrix
    }
  }

  @Test("Node with mesh")
  func nodeWithMesh() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)

    let nodeWithMesh = document.nodes.first { $0.mesh != nil }
    #expect(nodeWithMesh != nil, "Should have a node with a mesh")

    if let node = nodeWithMesh, let mesh = node.mesh {
      #expect(!mesh.name.isEmpty || mesh.name == "<unnamed>")
      #expect(mesh.primitives.count > 0)
    }
  }

  @Test("Node hierarchy")
  func nodeHierarchy() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)

    // Check parent-child relationships
    for node in document.nodes {
      if let parent = node.parent {
        #expect(parent.children.contains { $0.name == node.name } || node.name == "<unnamed>")
      }

      for child in node.children {
        #expect(child.parent?.name == node.name || node.name == "<unnamed>")
      }
    }
  }
}
