import CGLTF
import Foundation

public struct GLTFTexture: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_texture>
  public var name: String { cName(underlying.pointee.name) }
  public var image: GLTFImage? { wrapOptional(underlying.pointee.image) { GLTFImage(underlying: $0) } }
  public var sampler: GLTFSampler? {
    wrapOptional(underlying.pointee.sampler) { GLTFSampler(underlying: $0) }
  }
  public var hasBasisU: Bool { cBool(underlying.pointee.has_basisu) }
  public var basisUImage: GLTFImage? {
    wrapOptional(underlying.pointee.basisu_image) { GLTFImage(underlying: $0) }
  }
  public var hasWebP: Bool { cBool(underlying.pointee.has_webp) }
  public var webPImage: GLTFImage? {
    wrapOptional(underlying.pointee.webp_image) { GLTFImage(underlying: $0) }
  }
  public var debugDescription: String { "GLTFTexture(\(name))" }
}
