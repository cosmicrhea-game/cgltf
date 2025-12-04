import CGLTF
import Foundation

public typealias GLTFAlphaMode = CGLTF.GLTFAlphaMode

public struct GLTFMaterial: CustomDebugStringConvertible {
  internal let underlying: UnsafePointer<cgltf_material>

  public var name: String { cName(underlying.pointee.name) }

  public var hasPBRMetallicRoughness: Bool { cBool(underlying.pointee.has_pbr_metallic_roughness) }
  public var hasPBRSpecularGlossiness: Bool {
    cBool(underlying.pointee.has_pbr_specular_glossiness)
  }
  public var hasClearcoat: Bool { cBool(underlying.pointee.has_clearcoat) }
  public var hasTransmission: Bool { cBool(underlying.pointee.has_transmission) }
  public var hasVolume: Bool { cBool(underlying.pointee.has_volume) }
  public var hasIOR: Bool { cBool(underlying.pointee.has_ior) }
  public var hasSpecular: Bool { cBool(underlying.pointee.has_specular) }
  public var hasSheen: Bool { cBool(underlying.pointee.has_sheen) }
  public var hasEmissiveStrength: Bool { cBool(underlying.pointee.has_emissive_strength) }
  public var hasIridescence: Bool { cBool(underlying.pointee.has_iridescence) }
  public var hasDiffuseTransmission: Bool { cBool(underlying.pointee.has_diffuse_transmission) }
  public var hasAnisotropy: Bool { cBool(underlying.pointee.has_anisotropy) }
  public var hasDispersion: Bool { cBool(underlying.pointee.has_dispersion) }

  public var pbrMetallicRoughness: PBRMetallicRoughness {
    PBRMetallicRoughness(underlying: underlying.pointee.pbr_metallic_roughness)
  }
  public var pbrSpecularGlossiness: PBRSpecularGlossiness {
    PBRSpecularGlossiness(underlying: underlying.pointee.pbr_specular_glossiness)
  }
  public var clearcoat: Clearcoat { Clearcoat(underlying: underlying.pointee.clearcoat) }
  public var ior: IOR { IOR(underlying: underlying.pointee.ior) }
  public var specular: Specular { Specular(underlying: underlying.pointee.specular) }
  public var sheen: Sheen { Sheen(underlying: underlying.pointee.sheen) }
  public var transmission: Transmission {
    Transmission(underlying: underlying.pointee.transmission)
  }
  public var volume: Volume { Volume(underlying: underlying.pointee.volume) }
  public var emissiveStrengthStruct: EmissiveStrength {
    EmissiveStrength(underlying: underlying.pointee.emissive_strength)
  }
  public var iridescenceStruct: Iridescence {
    Iridescence(underlying: underlying.pointee.iridescence)
  }
  public var diffuseTransmissionStruct: DiffuseTransmission {
    DiffuseTransmission(underlying: underlying.pointee.diffuse_transmission)
  }
  public var anisotropyStruct: Anisotropy { Anisotropy(underlying: underlying.pointee.anisotropy) }
  public var dispersionStruct: Dispersion { Dispersion(underlying: underlying.pointee.dispersion) }

  public var normalTexture: GLTFTextureView {
    GLTFTextureView(underlying: underlying.pointee.normal_texture)
  }
  public var occlusionTexture: GLTFTextureView {
    GLTFTextureView(underlying: underlying.pointee.occlusion_texture)
  }
  public var emissiveTexture: GLTFTextureView {
    GLTFTextureView(underlying: underlying.pointee.emissive_texture)
  }

  public var emissiveFactor: [Float] {
    let ef = underlying.pointee.emissive_factor
    return [ef.0, ef.1, ef.2]
  }

  public var alphaMode: GLTFAlphaMode { underlying.pointee.alpha_mode }
  public var alphaCutoff: Float { underlying.pointee.alpha_cutoff }
  public var isDoubleSided: Bool { cBool(underlying.pointee.double_sided) }
  public var isUnlit: Bool { cBool(underlying.pointee.unlit) }

  public var debugDescription: String { "GLTFMaterial(\(name))" }

  public struct PBRMetallicRoughness: CustomDebugStringConvertible {
    internal let underlying: cgltf_pbr_metallic_roughness
    public var baseColorTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.base_color_texture)
    }
    public var metallicRoughnessTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.metallic_roughness_texture)
    }
    public var baseColorFactor: (Float, Float, Float, Float) {
      let f = underlying.base_color_factor
      return (f.0, f.1, f.2, f.3)
    }
    public var metallicFactor: Float { underlying.metallic_factor }
    public var roughnessFactor: Float { underlying.roughness_factor }
    public var debugDescription: String { "GLTFMaterial.PBRMetallicRoughness" }
  }

  public struct PBRSpecularGlossiness: CustomDebugStringConvertible {
    internal let underlying: cgltf_pbr_specular_glossiness
    public var diffuseTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.diffuse_texture)
    }
    public var specularGlossinessTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.specular_glossiness_texture)
    }
    public var diffuseFactor: (Float, Float, Float, Float) {
      let f = underlying.diffuse_factor
      return (f.0, f.1, f.2, f.3)
    }
    public var specularFactor: (Float, Float, Float) {
      let f = underlying.specular_factor
      return (f.0, f.1, f.2)
    }
    public var glossinessFactor: Float { underlying.glossiness_factor }
    public var debugDescription: String { "GLTFMaterial.PBRSpecularGlossiness" }
  }

  public struct Clearcoat: CustomDebugStringConvertible {
    internal let underlying: cgltf_clearcoat
    public var clearcoatTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.clearcoat_texture)
    }
    public var clearcoatRoughnessTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.clearcoat_roughness_texture)
    }
    public var clearcoatNormalTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.clearcoat_normal_texture)
    }
    public var clearcoatFactor: Float { underlying.clearcoat_factor }
    public var clearcoatRoughnessFactor: Float { underlying.clearcoat_roughness_factor }
    public var debugDescription: String { "GLTFMaterial.Clearcoat" }
  }

  public struct Transmission: CustomDebugStringConvertible {
    internal let underlying: cgltf_transmission
    public var transmissionTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.transmission_texture)
    }
    public var transmissionFactor: Float { underlying.transmission_factor }
    public var debugDescription: String { "GLTFMaterial.Transmission" }
  }

  public struct IOR: CustomDebugStringConvertible {
    internal let underlying: cgltf_ior
    public var ior: Float { underlying.ior }
    public var debugDescription: String { "GLTFMaterial.IOR(\(ior))" }
  }

  public struct Specular: CustomDebugStringConvertible {
    internal let underlying: cgltf_specular
    public var specularTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.specular_texture)
    }
    public var specularColorTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.specular_color_texture)
    }
    public var specularColorFactor: (Float, Float, Float) {
      let f = underlying.specular_color_factor
      return (f.0, f.1, f.2)
    }
    public var specularFactor: Float { underlying.specular_factor }
    public var debugDescription: String { "GLTFMaterial.Specular" }
  }

  public struct Volume: CustomDebugStringConvertible {
    internal let underlying: cgltf_volume
    public var thicknessTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.thickness_texture)
    }
    public var thicknessFactor: Float { underlying.thickness_factor }
    public var attenuationColor: (Float, Float, Float) {
      let c = underlying.attenuation_color
      return (c.0, c.1, c.2)
    }
    public var attenuationDistance: Float { underlying.attenuation_distance }
    public var debugDescription: String { "GLTFMaterial.Volume" }
  }

  public struct Sheen: CustomDebugStringConvertible {
    internal let underlying: cgltf_sheen
    public var sheenColorTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.sheen_color_texture)
    }
    public var sheenColorFactor: (Float, Float, Float) {
      let f = underlying.sheen_color_factor
      return (f.0, f.1, f.2)
    }
    public var sheenRoughnessTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.sheen_roughness_texture)
    }
    public var sheenRoughnessFactor: Float { underlying.sheen_roughness_factor }
    public var debugDescription: String { "GLTFMaterial.Sheen" }
  }

  public struct EmissiveStrength: CustomDebugStringConvertible {
    internal let underlying: cgltf_emissive_strength
    public var emissiveStrength: Float { underlying.emissive_strength }
    public var debugDescription: String { "GLTFMaterial.EmissiveStrength(\(emissiveStrength))" }
  }

  public struct Iridescence: CustomDebugStringConvertible {
    internal let underlying: cgltf_iridescence
    public var iridescenceFactor: Float { underlying.iridescence_factor }
    public var iridescenceTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.iridescence_texture)
    }
    public var iridescenceIor: Float { underlying.iridescence_ior }
    public var iridescenceThicknessMin: Float { underlying.iridescence_thickness_min }
    public var iridescenceThicknessMax: Float { underlying.iridescence_thickness_max }
    public var iridescenceThicknessTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.iridescence_thickness_texture)
    }
    public var debugDescription: String { "GLTFMaterial.Iridescence" }
  }

  public struct DiffuseTransmission: CustomDebugStringConvertible {
    internal let underlying: cgltf_diffuse_transmission
    public var diffuseTransmissionTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.diffuse_transmission_texture)
    }
    public var diffuseTransmissionFactor: Float { underlying.diffuse_transmission_factor }
    public var diffuseTransmissionColorFactor: (Float, Float, Float) {
      let f = underlying.diffuse_transmission_color_factor
      return (f.0, f.1, f.2)
    }
    public var diffuseTransmissionColorTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.diffuse_transmission_color_texture)
    }
    public var debugDescription: String { "GLTFMaterial.DiffuseTransmission" }
  }

  public struct Anisotropy: CustomDebugStringConvertible {
    internal let underlying: cgltf_anisotropy
    public var anisotropyStrength: Float { underlying.anisotropy_strength }
    public var anisotropyRotation: Float { underlying.anisotropy_rotation }
    public var anisotropyTexture: GLTFTextureView {
      GLTFTextureView(underlying: underlying.anisotropy_texture)
    }
    public var debugDescription: String {
      "GLTFMaterial.Anisotropy(strength: \(anisotropyStrength); rotation: \(anisotropyRotation)); texture: \(anisotropyTexture))"
    }
  }

  public struct Dispersion: CustomDebugStringConvertible {
    internal let underlying: cgltf_dispersion
    public var dispersion: Float { underlying.dispersion }
    public var debugDescription: String { "GLTFMaterial.Dispersion(\(dispersion))" }
  }
}
