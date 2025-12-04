import Foundation

func testResourceURL(name: String, extension: String) -> URL? {
  // Try Bundle.module first (for SPM resources)
  if let url = Bundle.module.url(forResource: name, withExtension: `extension`) {
    return url
  }

  // Fallback to relative path from test directory
  let testDir = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()  // Remove TestHelpers.swift
    .deletingLastPathComponent()  // Remove swift/
    .deletingLastPathComponent()  // Remove test/

  let resourcePath =
    testDir
    .appendingPathComponent("fuzz")
    .appendingPathComponent("data")
    .appendingPathComponent("\(name).\(`extension`)")

  return FileManager.default.fileExists(atPath: resourcePath.path) ? resourcePath : nil
}
