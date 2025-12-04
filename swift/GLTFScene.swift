import CGLTF
import Foundation

public struct GLTFScene: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_scene>
  public var name: String { cName(underlying.pointee.name) }
  public var nodes: [GLTFNode] {
    makeArrayPtr(ptr: underlying.pointee.nodes, count: Int(underlying.pointee.nodes_count)) { GLTFNode(underlying: $0) }
  }
  public var debugDescription: String { "GLTFScene(\(name), nodes: \(nodes.count))" }
}
