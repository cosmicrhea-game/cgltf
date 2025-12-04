import CGLTF
import Foundation

public struct GLTFLight: CustomDebugStringConvertible {
  public let underlying: UnsafePointer<cgltf_light>
  public var name: String { cName(underlying.pointee.name) }
  public var color: (Float, Float, Float) {
    let c = underlying.pointee.color
    return (c.0, c.1, c.2)
  }
  public var intensity: Float { underlying.pointee.intensity }
  public var type: GLTFLightType { underlying.pointee.type }
  public var range: Float { underlying.pointee.range }
  public var spotInnerConeAngle: Float { underlying.pointee.spot_inner_cone_angle }
  public var spotOuterConeAngle: Float { underlying.pointee.spot_outer_cone_angle }
  public var debugDescription: String { "GLTFLight(\(name))" }
}
