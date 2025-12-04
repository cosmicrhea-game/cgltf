import CGLTF
import Foundation

public struct GLTFBuffer: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_buffer>
  public var name: String { cName(underlying.pointee.name) }
  public var size: Int { Int(underlying.pointee.size) }
  public var uri: String { cName(underlying.pointee.uri) }
  public var dataPointer: UnsafeMutableRawPointer? { underlying.pointee.data }
  public var debugDescription: String { "GLTFBuffer(\(name), size: \(size))" }
}
