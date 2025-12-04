import CGLTF
import Foundation

public struct GLTFAnimation: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_animation>
  public var name: String { cName(underlying.pointee.name) }
  public var samplers: [Sampler] {
    makeArray(ptr: underlying.pointee.samplers, count: Int(underlying.pointee.samplers_count)) {
      Sampler(underlying: $0)
    }
  }
  public var channels: [Channel] {
    makeArray(ptr: underlying.pointee.channels, count: Int(underlying.pointee.channels_count)) {
      Channel(underlying: $0)
    }
  }
  public var debugDescription: String { "GLTFAnimation(\(name), channels: \(channels.count))" }

  public struct Sampler: CustomDebugStringConvertible {
    internal let underlying: UnsafePointer<cgltf_animation_sampler>
    public var input: GLTFAccessor {
      GLTFAccessor(underlying: UnsafePointer(underlying.pointee.input))
    }
    public var output: GLTFAccessor {
      GLTFAccessor(underlying: UnsafePointer(underlying.pointee.output))
    }
    public var interpolation: GLTFInterpolationType { underlying.pointee.interpolation }
    public var debugDescription: String { "GLTFAnimation.Sampler(interp: \(interpolation))" }
  }

  public struct Channel: CustomDebugStringConvertible {
    internal let underlying: UnsafePointer<cgltf_animation_channel>
    public var sampler: Sampler { Sampler(underlying: UnsafePointer(underlying.pointee.sampler)) }
    public var targetNode: GLTFNode? {
      wrapOptional(underlying.pointee.target_node) { GLTFNode(underlying: $0) }
    }
    public var targetPath: GLTFAnimationPathType { underlying.pointee.target_path }
    public var debugDescription: String { "GLTFAnimation.Channel(path: \(targetPath))" }
  }
}
