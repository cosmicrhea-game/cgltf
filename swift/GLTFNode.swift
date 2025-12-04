import CGLTF
import Foundation

public struct GLTFNode: CustomDebugStringConvertible {
  public let underlying: UnsafePointer<cgltf_node>
  public var name: String { cName(underlying.pointee.name) }
  public var parent: GLTFNode? {
    wrapOptional(underlying.pointee.parent) { GLTFNode(underlying: $0) }
  }
  public var children: [GLTFNode] {
    makeArrayPtr(ptr: underlying.pointee.children, count: Int(underlying.pointee.children_count)) {
      GLTFNode(underlying: $0)
    }
  }
  public var skin: GLTFSkin? { wrapOptional(underlying.pointee.skin) { GLTFSkin(underlying: $0) } }
  public var mesh: GLTFMesh? { wrapOptional(underlying.pointee.mesh) { GLTFMesh(underlying: $0) } }
  public var camera: GLTFCamera? {
    wrapOptional(underlying.pointee.camera) { GLTFCamera(underlying: $0) }
  }
  public var light: GLTFLight? {
    wrapOptional(underlying.pointee.light) { GLTFLight(underlying: $0) }
  }
  public var weights: [Float] {
    guard let base = underlying.pointee.weights, underlying.pointee.weights_count > 0 else {
      return []
    }
    return (0..<Int(underlying.pointee.weights_count)).map { base.advanced(by: $0).pointee }
  }
  public var hasTranslation: Bool { cBool(underlying.pointee.has_translation) }
  public var hasRotation: Bool { cBool(underlying.pointee.has_rotation) }
  public var hasScale: Bool { cBool(underlying.pointee.has_scale) }
  public var hasMatrix: Bool { cBool(underlying.pointee.has_matrix) }
  public var translation: (Float, Float, Float) {
    let t = underlying.pointee.translation
    return (t.0, t.1, t.2)
  }
  public var rotation: (Float, Float, Float, Float) {
    let r = underlying.pointee.rotation
    return (r.0, r.1, r.2, r.3)
  }
  public var scale: (Float, Float, Float) {
    let s = underlying.pointee.scale
    return (s.0, s.1, s.2)
  }
  public var matrix: [Float] {
    let m = underlying.pointee.matrix
    return [m.0, m.1, m.2, m.3, m.4, m.5, m.6, m.7, m.8, m.9, m.10, m.11, m.12, m.13, m.14, m.15]
  }

  /// Computes the local transform matrix for this node using cgltf's built-in function.
  /// Returns a 16-element array representing a column-major 4x4 matrix.
  /// This handles both explicit matrices and TRS (translation, rotation, scale) components.
  public var localTransformMatrix: [Float] {
    var result: [Float] = Array(repeating: 0, count: 16)
    result.withUnsafeMutableBufferPointer { buffer in
      if let baseAddress = buffer.baseAddress {
        // Use cgltf's function to compute the local transform matrix
        // This ensures we match exactly how cgltf computes transforms
        // Note: cgltf_node_transform_local takes const cgltf_node*, so we can pass underlying directly
        cgltf_node_transform_local(underlying, baseAddress)
      }
    }
    return result
  }

  /// Get the extras JSON data for this node
  /// Returns the raw JSON string from the extras field, or nil if not present
  public var extrasJSON: String? {
    guard let data = underlying.pointee.extras.data else { return nil }
    return String(cString: data)
  }

  public var debugDescription: String { "GLTFNode(\(name))" }
}
