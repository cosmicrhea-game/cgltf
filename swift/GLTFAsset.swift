import CGLTF
import Foundation

public struct GLTFAsset: CustomDebugStringConvertible {
  internal let underlying: cgltf_asset
  public var copyright: String { cName(underlying.copyright) }
  public var generator: String { cName(underlying.generator) }
  public var version: String { cName(underlying.version) }
  public var minVersion: String { cName(underlying.min_version) }
  public var debugDescription: String { "GLTFAsset(version: \(version))" }
}
