import CGLTF
import Foundation

public struct GLTFMesh: CustomDebugStringConvertible {
  public let underlying: UnsafePointer<cgltf_mesh>

  public var name: String { cName(underlying.pointee.name) }

  public var primitives: [GLTFPrimitive] {
    makeArray(ptr: underlying.pointee.primitives, count: Int(underlying.pointee.primitives_count)) {
      GLTFPrimitive(underlying: $0)
    }
  }

  public var weights: [Float] {
    guard let base = underlying.pointee.weights, underlying.pointee.weights_count > 0 else { return [] }
    return (0..<Int(underlying.pointee.weights_count)).map { base.advanced(by: $0).pointee }
  }

  public var targetNames: [String] {
    guard let base = underlying.pointee.target_names, underlying.pointee.target_names_count > 0 else { return [] }
    return (0..<Int(underlying.pointee.target_names_count)).map { idx in
      cName(UnsafePointer(base.advanced(by: idx).pointee))
    }
  }

  public var debugDescription: String { "GLTFMesh(\(name))" }
}


