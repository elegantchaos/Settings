// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/01/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Extensions for accessing AppSettingKey values through UserDefaults.
extension UserDefaults {
  /// Reconstructs a raw-representable preference, falling back to the key's default.
  public func value<V>(forKey key: AppSettingKey<V>) -> V where V: RawRepresentable {
    if let raw = object(forKey: key.key) as? V.RawValue, let value = V(rawValue: raw) {
      return value
    }
    return key.defaultValue
  }

  /// Persists the raw representation of a typed preference.
  public func set<V>(_ value: V, forKey key: AppSettingKey<V>) where V: RawRepresentable {
    set(value.rawValue, forKey: key.key)
  }

  /// Reads a typed preference, using its default when absent or of a different type.
  public func value<V>(forKey key: AppSettingKey<V>) -> V {
    let value = object(forKey: key.key) as? V
    return value ?? key.defaultValue
  }

  /// Persists a supported primitive preference through its typed key.
  public func set<V>(_ value: V, forKey key: AppSettingKey<V>) where V: SettingsCompatible {
    set(value, forKey: key.key)
  }

  /// Returns whether the defaults search list contains a value for this key.
  public func hasKey<V>(_ key: AppSettingKey<V>) -> Bool {
    object(forKey: key.key) != nil
  }
}

/// A snapshot of the settings values for a group of keys.
public struct SettingsSnapshot<each V> {
  /// Captured keys and their associated values, in the caller's requested order.
  let values: (repeat (AppSettingKey<each V>, Any?))

  /// Log the keys and values.
  public func print() {
    for v in repeat each values {
      Swift.print("\(v.0): \(v.1 ?? "<nil>")")
    }
  }
}

/// Compares captured values after casting them to their keys' declared types.
extension SettingsSnapshot: Equatable where repeat each V: Equatable {
  /// Returns whether the corresponding captured values are equal.
  public static func == (lhs: SettingsSnapshot<repeat each V>, rhs: SettingsSnapshot<repeat each V>)
    -> Bool
  {
    for v in repeat (each lhs.values, each rhs.values) {
      if v.0.0.typedValue(v.0.1) != v.1.0.typedValue(v.1.1) {
        return false
      }
    }
    return true
  }
}

/// Captures and restores groups of typed preferences.
extension UserDefaults {
  /// Return a snapshot of the current values for a group of keys.
  public func snapshot<each V>(for keys: repeat AppSettingKey<each V>) -> SettingsSnapshot<
    repeat each V
  > {
    return SettingsSnapshot(
      values: (repeat (each keys, value(forKey: each keys)))
    )
  }

  /// Restore a snapshot of the values for a group of keys.
  public func restore<each V>(
    from snapshot: SettingsSnapshot<repeat each V>
  ) {
    for v in repeat each snapshot.values {
      set(v.1, forKey: v.0.key)
    }
  }

}
