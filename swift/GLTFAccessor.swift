import CGLTF
import Foundation

public struct GLTFAccessor: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_accessor>
  public var name: String { cName(underlying.pointee.name) }
  public var componentType: GLTFComponentType { underlying.pointee.component_type }
  public var normalized: Bool { cBool(underlying.pointee.normalized) }
  public var type: GLTFAccessorType { underlying.pointee.type }
  public var offset: Int { Int(underlying.pointee.offset) }
  public var count: Int { Int(underlying.pointee.count) }
  public var stride: Int { Int(underlying.pointee.stride) }
  public var bufferView: GLTFBufferView? {
    wrapOptional(underlying.pointee.buffer_view) { GLTFBufferView(underlying: $0) }
  }
  public var hasMin: Bool { cBool(underlying.pointee.has_min) }
  public var hasMax: Bool { cBool(underlying.pointee.has_max) }
  public var isSparse: Bool { cBool(underlying.pointee.is_sparse) }

  /// Read a single index value using cgltf's helper function.
  /// This handles sparse accessors, stride calculation, and component type conversion correctly.
  public func readIndex(at index: Int) -> UInt32 {
    return UInt32(cgltf_accessor_read_index(underlying, cgltf_size(index)))
  }

  /// Unpack all indices into a UInt32 array using cgltf's helper function.
  /// This is the recommended way to read index data as it handles all edge cases.
  public func unpackIndices() -> [UInt32]? {
    guard !isSparse else {
      // Sparse accessors not supported by unpack_indices
      return nil
    }

    // Validate buffer view and buffer are valid before reading
    guard let bufferView = self.bufferView,
      bufferView.dataPointer != nil
    else {
      return nil
    }

    // Calculate component size
    let componentSize: Int
    switch componentType {
    case .r_8u: componentSize = 1
    case .r_16u: componentSize = 2
    case .r_32u: componentSize = 4
    default: return nil
    }

    // Validate buffer view size
    let actualStride = stride > 0 ? stride : componentSize
    let minRequiredSize = offset + (count - 1) * actualStride + componentSize
    guard minRequiredSize <= bufferView.size else {
      return nil
    }

    // Allocate output buffer
    var indices = [UInt32](repeating: 0, count: count)

    // Call cgltf function
    let unpackedCount = indices.withUnsafeMutableBufferPointer { buffer in
      cgltf_accessor_unpack_indices(
        underlying, buffer.baseAddress, MemoryLayout<UInt32>.size, cgltf_size(count))
    }

    guard unpackedCount == count else {
      return nil
    }

    // Validate the extracted indices are reasonable
    let maxIndex = indices.max() ?? 0
    let minIndex = indices.min() ?? 0

    // Check for obviously corrupted data
    if maxIndex > 1_000_000 || (minIndex > 0 && maxIndex < minIndex) {
      return nil
    }

    return indices
  }

  /// Unpack all float data using cgltf's helper function.
  /// This handles sparse accessors, normalization, stride, and component type conversion correctly.
  public func unpackFloats() -> [Float]? {
    // First call with NULL to get required float count
    let requiredFloats = cgltf_accessor_unpack_floats(underlying, nil, 0)
    guard requiredFloats > 0 else {
      return nil
    }

    // Allocate output buffer
    var floats = [Float](repeating: 0, count: Int(requiredFloats))
    let unpackedCount = floats.withUnsafeMutableBufferPointer { buffer in
      cgltf_accessor_unpack_floats(underlying, buffer.baseAddress, cgltf_size(requiredFloats))
    }

    guard unpackedCount == requiredFloats else {
      return nil
    }

    return floats
  }

  public var debugDescription: String { "GLTFAccessor(\(name), count: \(count))" }
}
