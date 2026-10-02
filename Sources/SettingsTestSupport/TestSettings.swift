//
//  TestSettings.swift
//  Settings
//
//  Created by Sam Deane on 02/10/2026.
//

import Foundation

/// Settings that live in memory, isolated to one test.
///
/// A real suite leaves a preferences file behind once anything is written to it, and
/// `removePersistentDomain(forName:)` only empties that file. Keeping the values out of the
/// preferences system is the only way for a test to leave nothing behind.
///
/// SwiftUI's `@AppStorage` reads and writes these values when given the instance as its
/// store. Changes send no key-value observation notifications, so nothing that observes
/// the settings, including a live view, is told about them. Tests that need that should
/// use ``persistentSuite(prefix:)`` instead.
public nonisolated final class TestSettings: UserDefaults, @unchecked Sendable {
  /// The suite every instance is nominally attached to. Nothing is ever written to it.
  public static let suiteName = "SettingsTestSupport.TestSettings"

  private let lock = NSLock()
  private var values: [String: Any] = [:]

  /// Creates empty settings.
  public init() {
    // The suite name is only refused when it names the main bundle or the global domain.
    super.init(suiteName: Self.suiteName)!
  }

  // Foundation's typed accessors route through these three methods.

  public override func object(forKey defaultName: String) -> Any? {
    lock.withLock { values[defaultName] }
  }

  public override func set(_ value: Any?, forKey defaultName: String) {
    lock.withLock { values[defaultName] = value }
  }

  public override func removeObject(forKey defaultName: String) {
    lock.withLock { values[defaultName] = nil }
  }
}

extension TestSettings {
  /// Returns a unique name for a real suite, in the form `<prefix>-<UUID>`.
  public static func persistentSuiteName(prefix: String) -> String {
    "\(prefix)-\(UUID().uuidString)"
  }

  /// Creates a real suite for a test that needs the preferences system.
  ///
  /// Writing to the suite leaves a `<prefix>-<UUID>.plist` in the user's preferences that
  /// nothing removes. The prefix is there so the leftovers can be recognised and deleted.
  public static func persistentSuite(prefix: String) -> UserDefaults {
    let name = persistentSuiteName(prefix: prefix)
    guard let suite = UserDefaults(suiteName: name) else {
      preconditionFailure("Could not create test settings suite \(name)")
    }
    return suite
  }
}
