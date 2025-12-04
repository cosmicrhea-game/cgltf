import CGLTF
import Foundation

public final class GLTFDocument: @unchecked Sendable {
  internal let underlying: UnsafeMutablePointer<cgltf_data>

  // Keep the original Data alive for GLB files
  // cgltf_parse() stores a pointer to the binary chunk (data->bin) which points
  // into this Data object's memory. If this Data is deallocated, all buffer
  // data becomes invalid.
  private let _data: Data?

  internal init(underlying: UnsafeMutablePointer<cgltf_data>, data: Data? = nil) {
    self.underlying = underlying
    self._data = data
  }

  deinit { cgltf_free(underlying) }

  public var asset: cgltf_asset { underlying.pointee.asset }
  public var copyright: String { cName(underlying.pointee.asset.copyright) }
  public var generator: String { cName(underlying.pointee.asset.generator) }
  public var version: String { cName(underlying.pointee.asset.version) }
  public var minimumVersion: String { cName(underlying.pointee.asset.min_version) }

  public var scenes: [GLTFScene] {
    makeArray(ptr: underlying.pointee.scenes, count: Int(underlying.pointee.scenes_count)) {
      GLTFScene(underlying: $0)
    }
  }
  public var nodes: [GLTFNode] {
    makeArray(ptr: underlying.pointee.nodes, count: Int(underlying.pointee.nodes_count)) {
      GLTFNode(underlying: $0)
    }
  }
  public var meshes: [GLTFMesh] {
    makeArray(ptr: underlying.pointee.meshes, count: Int(underlying.pointee.meshes_count)) {
      GLTFMesh(underlying: $0)
    }
  }
  public var materials: [GLTFMaterial] {
    makeArray(ptr: underlying.pointee.materials, count: Int(underlying.pointee.materials_count)) {
      GLTFMaterial(underlying: $0)
    }
  }
  public var cameras: [GLTFCamera] {
    makeArray(ptr: underlying.pointee.cameras, count: Int(underlying.pointee.cameras_count)) {
      GLTFCamera(underlying: $0)
    }
  }
  public var lights: [GLTFLight] {
    makeArray(ptr: underlying.pointee.lights, count: Int(underlying.pointee.lights_count)) {
      GLTFLight(underlying: $0)
    }
  }
  public var skins: [GLTFSkin] {
    makeArray(ptr: underlying.pointee.skins, count: Int(underlying.pointee.skins_count)) {
      GLTFSkin(underlying: $0)
    }
  }
  public var animations: [GLTFAnimation] {
    makeArray(ptr: underlying.pointee.animations, count: Int(underlying.pointee.animations_count)) {
      GLTFAnimation(underlying: $0)
    }
  }
  public var textures: [GLTFTexture] {
    makeArray(ptr: underlying.pointee.textures, count: Int(underlying.pointee.textures_count)) {
      GLTFTexture(underlying: $0)
    }
  }
  public var images: [GLTFImage] {
    makeArray(ptr: underlying.pointee.images, count: Int(underlying.pointee.images_count)) {
      GLTFImage(underlying: $0)
    }
  }
  public var bufferViews: [GLTFBufferView] {
    makeArray(
      ptr: underlying.pointee.buffer_views, count: Int(underlying.pointee.buffer_views_count)
    ) { GLTFBufferView(underlying: $0) }
  }
  public var buffers: [GLTFBuffer] {
    makeArray(ptr: underlying.pointee.buffers, count: Int(underlying.pointee.buffers_count)) {
      GLTFBuffer(underlying: $0)
    }
  }
  public var accessors: [GLTFAccessor] {
    makeArray(ptr: underlying.pointee.accessors, count: Int(underlying.pointee.accessors_count)) {
      GLTFAccessor(underlying: $0)
    }
  }
}

public enum GLTFError: Error {
  case ioError
  case parseError(Int)
}

extension GLTFDocument {
  public typealias ProgressHandler = (Double) -> Void

  public convenience init(
    contentsOf url: URL,
    onProgress: ProgressHandler? = nil
  ) async throws {
    let file = try FileHandle(forReadingFrom: url)
    defer { try? file.close() }

    let total = try file.seekToEnd()
    try file.seek(toOffset: 0)

    var data = Data(capacity: Int(total))
    let chunkSize = 64 * 1024
    var readTotal: UInt64 = 0

    while autoreleasepool(invoking: {
      if let chunk = try? file.read(upToCount: chunkSize), !chunk.isEmpty {
        data.append(chunk)
        readTotal += UInt64(chunk.count)
        onProgress?(Double(readTotal) / Double(total))
        return true
      }
      return false
    }) {}

    var cgltfData: UnsafeMutablePointer<cgltf_data>?
    var options = cgltf_options()

    let result = data.withUnsafeBytes { bytes -> cgltf_result in
      cgltf_parse(&options, bytes.baseAddress, cgltf_size(bytes.count), &cgltfData)
    }

    guard result == cgltf_result_success, let parsed = cgltfData else {
      throw GLTFError.parseError(Int(result.rawValue))
    }

    // Load buffer data - this is critical, must succeed
    let bufferResult = cgltf_load_buffers(&options, parsed, url.path)
    guard bufferResult == cgltf_result_success else {
      throw GLTFError.parseError(Int(bufferResult.rawValue))
    }

    // Keep the Data object alive for GLB files
    // For GLB files, cgltf stores a pointer to the binary chunk (parsed->bin) which
    // points into this Data object's memory. If we don't keep it alive, buffer data
    // becomes invalid.
    self.init(underlying: parsed, data: data)
  }
}

@inline(__always)
func makeArray<T, W>(
  ptr: UnsafeMutablePointer<T>?,
  count: Int,
  wrap: (UnsafePointer<T>) -> W
) -> [W] {
  guard let base = ptr, count > 0 else { return [] }
  return (0..<count).map { index in
    wrap(UnsafePointer(base.advanced(by: index)))
  }
}

@inline(__always)
func cName(_ ptr: UnsafePointer<CChar>?) -> String {
  guard let ptr else { return "<unnamed>" }
  return String(cString: ptr)
}

@inline(__always)
func cBool(_ v: cgltf_bool) -> Bool { v != 0 }

@inline(__always)
func makeArrayPtr<T, W>(
  ptr: UnsafeMutablePointer<UnsafeMutablePointer<T>?>?,
  count: Int,
  wrap: (UnsafePointer<T>) -> W
) -> [W] {
  guard let base = ptr, count > 0 else { return [] }
  return (0..<count).compactMap { index in
    guard let p = base.advanced(by: index).pointee else { return nil }
    return wrap(UnsafePointer(p))
  }
}

@inline(__always)
func wrapOptional<T, W>(_ ptr: UnsafeMutablePointer<T>?, as wrap: (UnsafePointer<T>) -> W) -> W? {
  guard let ptr else { return nil }
  return wrap(UnsafePointer(ptr))
}
