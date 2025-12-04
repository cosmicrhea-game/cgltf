import CGLTF
import Foundation

public struct GLTFSkin: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_skin>
  public var name: String { cName(underlying.pointee.name) }
  public var joints: [GLTFNode] { makeArrayPtr(ptr: underlying.pointee.joints, count: Int(underlying.pointee.joints_count)) { GLTFNode(underlying: $0) } }
  public var skeleton: GLTFNode? { wrapOptional(underlying.pointee.skeleton) { GLTFNode(underlying: $0) } }
  public var inverseBindMatrices: GLTFAccessor? { wrapOptional(underlying.pointee.inverse_bind_matrices) { GLTFAccessor(underlying: $0) } }
  public var debugDescription: String { "GLTFSkin(\(name), joints: \(joints.count))" }
}


