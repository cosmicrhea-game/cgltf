import CGLTF
import Foundation

public struct GLTFTextureView: CustomDebugStringConvertible {
  internal let underlying: cgltf_texture_view
  public var texture: GLTFTexture? { wrapOptional(underlying.texture) { GLTFTexture(underlying: $0) } }
  public var texcoord: Int { Int(underlying.texcoord) }
  public var scale: Float { underlying.scale }
  public var hasTransform: Bool { cBool(underlying.has_transform) }
  public var transform: GLTFTextureTransform { GLTFTextureTransform(underlying: underlying.transform) }
  public var debugDescription: String { "GLTFTextureView(texcoord: \(texcoord))" }
}

public struct GLTFTextureTransform: CustomDebugStringConvertible {
  internal let underlying: cgltf_texture_transform
  public var offset: (Float, Float) {
    let o = underlying.offset
    return (o.0, o.1)
  }
  public var rotation: Float { underlying.rotation }
  public var scale: (Float, Float) {
    let s = underlying.scale
    return (s.0, s.1)
  }
  public var hasTexcoord: Bool { cBool(underlying.has_texcoord) }
  public var texcoord: Int { Int(underlying.texcoord) }
  public var debugDescription: String { "GLTFTextureTransform(rot: \(rotation))" }
}
