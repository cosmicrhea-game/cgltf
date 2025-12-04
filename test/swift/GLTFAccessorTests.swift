import Foundation
import Testing

@testable import GLTF

struct GLTFAccessorTests {
  @Test("Accessor properties are accessible")
  func accessorProperties() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)
    #expect(document.accessors.count > 0)

    let accessor = document.accessors[0]

    let _ = accessor.name
    let _ = accessor.componentType
    let _ = accessor.normalized
    let _ = accessor.type
    let _ = accessor.offset
    #expect(accessor.count > 0)
    let _ = accessor.stride
    let _ = accessor.bufferView
    let _ = accessor.hasMin
    let _ = accessor.hasMax
    let _ = accessor.isSparse
  }

  @Test("Accessor buffer view relationship")
  func accessorBufferView() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)

    for accessor in document.accessors {
      if let bufferView = accessor.bufferView {
        #expect(bufferView.buffer != nil || bufferView.name == "<unnamed>")
      }
    }
  }
}
