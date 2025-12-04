import Foundation
import Testing

@testable import GLTF

struct GLTFMeshTests {
  @Test("Mesh properties are accessible")
  func meshProperties() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)
    #expect(document.meshes.count > 0)

    let mesh = document.meshes[0]

    let _ = mesh.name
    #expect(mesh.primitives.count > 0)
    let _ = mesh.weights
    let _ = mesh.targetNames
  }

  @Test("Mesh primitives")
  func meshPrimitives() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)

    for mesh in document.meshes {
      for primitive in mesh.primitives {
        let _ = primitive.type
        let _ = primitive.indices
        let _ = primitive.material
        let _ = primitive.attributes
        let _ = primitive.targets
        let _ = primitive.hasDracoCompression

        if primitive.hasDracoCompression {
          let _ = primitive.draco
        }
      }
    }
  }

  @Test("Primitive attributes")
  func primitiveAttributes() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)

    for mesh in document.meshes {
      for primitive in mesh.primitives {
        for attribute in primitive.attributes {
          let _ = attribute.name
          let _ = attribute.type
          let _ = attribute.index
          let _ = attribute.data
        }
      }
    }
  }
}
