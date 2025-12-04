import CGLTF
import Foundation

public struct GLTFImage: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_image>
  public var name: String { cName(underlying.pointee.name) }
  public var uri: String { cName(underlying.pointee.uri) }
  public var bufferView: GLTFBufferView? {
    wrapOptional(underlying.pointee.buffer_view) { GLTFBufferView(underlying: $0) }
  }
  public var mimeType: String { cName(underlying.pointee.mime_type) }
  public var debugDescription: String { "GLTFImage(\(name))" }
}
