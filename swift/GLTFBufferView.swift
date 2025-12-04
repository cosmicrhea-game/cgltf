import CGLTF
import Foundation

public struct GLTFBufferView: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_buffer_view>
  public var name: String { cName(underlying.pointee.name) }
  public var buffer: GLTFBuffer? {
    wrapOptional(underlying.pointee.buffer) { GLTFBuffer(underlying: $0) }
  }
  public var offset: Int { Int(underlying.pointee.offset) }
  public var size: Int { Int(underlying.pointee.size) }
  public var stride: Int { Int(underlying.pointee.stride) }
  public var type: GLTFBufferViewType { underlying.pointee.type }
  public var hasMeshoptCompression: Bool { cBool(underlying.pointee.has_meshopt_compression) }

  /// Get the data pointer for this buffer view.
  /// This uses cgltf's cgltf_buffer_view_data() function which correctly handles:
  /// - Buffer views with their own data pointer (from extensions)
  /// - Proper offset calculation from the underlying buffer
  /// - NULL checks
  ///
  /// Note: This pointer is only valid as long as the underlying cgltf_data and its buffers
  /// remain valid. The GLTFDocument must be kept alive to ensure buffer data is not freed.
  public var dataPointer: UnsafePointer<UInt8>? {
    // Validate buffer exists and has data before getting pointer
    guard let buffer = self.buffer,
      buffer.dataPointer != nil
    else {
      return nil
    }
    let ptr = cgltf_buffer_view_data(underlying)
    return ptr
  }

  public var debugDescription: String { "GLTFBufferView(\(name))" }
}
