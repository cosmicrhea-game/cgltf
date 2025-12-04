import CGLTF
import Foundation

public struct GLTFCamera: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_camera>
  public var name: String { cName(underlying.pointee.name) }
  public var type: GLTFCameraType { underlying.pointee.type }
  public var perspective: Perspective {
    Perspective(underlying: underlying.pointee.data.perspective)
  }
  public var orthographic: Orthographic {
    Orthographic(underlying: underlying.pointee.data.orthographic)
  }
  public var debugDescription: String { "GLTFCamera(\(name))" }

  public struct Perspective: CustomDebugStringConvertible {
    internal let underlying: cgltf_camera_perspective
    public var hasAspectRatio: Bool { cBool(underlying.has_aspect_ratio) }
    public var aspectRatio: Float { underlying.aspect_ratio }
    public var yfov: Float { underlying.yfov }
    public var hasZFar: Bool { cBool(underlying.has_zfar) }
    public var zfar: Float { underlying.zfar }
    public var znear: Float { underlying.znear }
    public var debugDescription: String { "GLTFCamera.Perspective(fov: \(yfov))" }
  }

  public struct Orthographic: CustomDebugStringConvertible {
    internal let underlying: cgltf_camera_orthographic
    public var xmag: Float { underlying.xmag }
    public var ymag: Float { underlying.ymag }
    public var zfar: Float { underlying.zfar }
    public var znear: Float { underlying.znear }
    public var debugDescription: String { "GLTFCamera.Orthographic(xmag: \(xmag), ymag: \(ymag))" }
  }
}
