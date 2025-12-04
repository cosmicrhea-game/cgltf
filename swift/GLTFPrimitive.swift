import CGLTF
import Foundation

public struct GLTFPrimitive: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_primitive>

  public var type: GLTFPrimitiveType { underlying.pointee.type }
  public var indices: GLTFAccessor? {
    wrapOptional(underlying.pointee.indices) { GLTFAccessor(underlying: $0) }
  }
  public var material: GLTFMaterial? {
    wrapOptional(underlying.pointee.material) { GLTFMaterial(underlying: $0) }
  }

  public var attributes: [Attribute] {
    makeArray(ptr: underlying.pointee.attributes, count: Int(underlying.pointee.attributes_count)) {
      Attribute(underlying: $0)
    }
  }

  public var targets: [GLTFMorphTarget] {
    makeArray(ptr: underlying.pointee.targets, count: Int(underlying.pointee.targets_count)) {
      GLTFMorphTarget(underlying: $0)
    }
  }

  public var hasDracoCompression: Bool { cBool(underlying.pointee.has_draco_mesh_compression) }
  public var draco: GLTFDracoMeshCompression? {
    hasDracoCompression
      ? GLTFDracoMeshCompression(underlying: underlying.pointee.draco_mesh_compression) : nil
  }

  public var debugDescription: String { "GLTFPrimitive(type: \(type))" }
}

public struct Attribute: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_attribute>
  public var name: String { cName(underlying.pointee.name) }
  public var type: GLTFAttributeType { underlying.pointee.type }
  public var index: Int { Int(underlying.pointee.index) }
  public var data: GLTFAccessor { GLTFAccessor(underlying: UnsafePointer(underlying.pointee.data)) }
  public var debugDescription: String { "Attribute(\(name))" }
}

public struct GLTFMorphTarget: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_morph_target>
  public var attributes: [Attribute] {
    makeArray(ptr: underlying.pointee.attributes, count: Int(underlying.pointee.attributes_count)) {
      Attribute(underlying: $0)
    }
  }
  public var debugDescription: String { "GLTFMorphTarget(attributes: \(attributes.count))" }
}

public struct GLTFDracoMeshCompression: CustomDebugStringConvertible {
  internal let underlying: cgltf_draco_mesh_compression
  public var bufferView: GLTFBufferView? {
    wrapOptional(underlying.buffer_view) { GLTFBufferView(underlying: $0) }
  }
  public var attributes: [Attribute] {
    makeArray(ptr: underlying.attributes, count: Int(underlying.attributes_count)) {
      Attribute(underlying: $0)
    }
  }
  public var debugDescription: String { "GLTFDracoMeshCompression(attrs: \(attributes.count))" }
}
