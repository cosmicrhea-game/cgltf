import CGLTF
import Foundation

public typealias GLTFFilterType = CGLTF.GLTFFilterType
public typealias GLTFWrapMode = CGLTF.GLTFWrapMode

public struct GLTFSampler: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_sampler>
  public var name: String { cName(underlying.pointee.name) }
  public var magFilter: GLTFFilterType { underlying.pointee.mag_filter }
  public var minFilter: GLTFFilterType { underlying.pointee.min_filter }
  public var wrapS: GLTFWrapMode { underlying.pointee.wrap_s }
  public var wrapT: GLTFWrapMode { underlying.pointee.wrap_t }
  public var debugDescription: String { "GLTFSampler(\(name))" }
}
