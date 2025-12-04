import Foundation
import Testing

@testable import GLTF

struct GLTFDocumentTests {
  @Test("Load GLTF document from file")
  func loadDocument() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)

    #expect(document.version == "2.0")
    #expect(document.scenes.count == 1)
    #expect(document.nodes.count == 1)
    #expect(document.meshes.count == 1)
    #expect(document.accessors.count == 1)
    #expect(document.buffers.count == 1)
    #expect(document.bufferViews.count == 1)
  }

  @Test("Document properties are accessible")
  func documentProperties() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    let document = try await GLTFDocument(contentsOf: testFile)

    // Asset properties
    #expect(!document.version.isEmpty)
    #expect(!document.generator.isEmpty || document.generator == "<unnamed>")

    // Collections should be accessible
    let _ = document.scenes
    let _ = document.nodes
    let _ = document.meshes
    let _ = document.materials
    let _ = document.cameras
    let _ = document.lights
    let _ = document.skins
    let _ = document.animations
    let _ = document.textures
    let _ = document.images
    let _ = document.bufferViews
    let _ = document.buffers
    let _ = document.accessors
  }

  @Test("Progress handler is called")
  func progressHandler() async throws {
    guard let testFile = testResourceURL(name: "TriangleWithoutIndices", extension: "gltf") else {
      Issue.record("Test file should exist")
      return
    }

    var progressValues: [Double] = []

    let document = try await GLTFDocument(
      contentsOf: testFile,
      onProgress: { progress in
        progressValues.append(progress)
      }
    )

    #expect(!progressValues.isEmpty, "Progress should be reported")
    #expect(progressValues.last == 1.0, "Final progress should be 1.0")
    #expect(document.version == "2.0")
  }

  @Test("Invalid file throws error")
  func invalidFileThrows() async throws {
    let invalidURL = URL(fileURLWithPath: "/nonexistent/file.gltf")

    // FileHandle throws NSError for missing files, not GLTFError
    do {
      _ = try await GLTFDocument(contentsOf: invalidURL)
      Issue.record("Expected error to be thrown")
    } catch {
      // Expected - any error is fine for this test
      // Error was thrown, which is what we want
    }
  }
}
