// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/01/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Extensions for accessing AppSettingKey values through UserDefaults.
public extension UserDefaults {
  func value<V>(forKey key: AppSettingKey<V>) -> V where V: RawRepresentable {
    if let raw = object(forKey: key.key) as? V.RawValue, let value = V(rawValue: raw) {
      return value
    }
    return key.defaultValue
  }
  
  func set<V>(_ value: V, forKey key: AppSettingKey<V>) where V: RawRepresentable {
    set(value.rawValue, forKey: key.key)
  }

  func value<V>(forKey key: AppSettingKey<V>) -> V {
    let value = object(forKey: key.key) as? V
    return value ?? key.defaultValue
  }
  
  func set<V>(_ value: V, forKey key: AppSettingKey<V>) where V: SettingsCompatible {
    set(value, forKey: key.key)
  }
}

/// A snapshot of the settings values for a group of keys.
public struct SettingsSnapshot<each V> {
  let values: (repeat (AppSettingKey<each V>, Any?))
  init(values: (repeat (AppSettingKey<each V>, Any?))) {
    self.values = values
  }

  /// Log the keys and values.
  public func print() {
    for v in repeat each values {
      Swift.print("\(v.0): \(v.1 ?? "<nil>")")
    }
  }
}

extension SettingsSnapshot: Equatable where repeat each V:Equatable {
  public static func == (lhs: SettingsSnapshot<repeat each V>, rhs: SettingsSnapshot<repeat each V>) -> Bool {
    for v in repeat (each lhs.values, each rhs.values) {
      if v.0.0.typedValue(v.0.1) != v.1.0.typedValue(v.1.1) {
        return false
      }
    }
    return true
  }
}

public extension UserDefaults {
  /// Return a snapshot of the current values for a group of keys.
  func snapshot<each V>(for keys: repeat AppSettingKey<each V>) -> SettingsSnapshot<repeat each V> {
    return SettingsSnapshot(
      values: (repeat (each keys, value(forKey: each keys)))
    )
  }
  
  /// Restore a snapshot of the values for a group of keys.
  func restore<each V>(
    from snapshot: SettingsSnapshot<repeat each V>
  ) {
    for v in repeat each snapshot.values {
      set(v.1, forKey: v.0.key)
    }
  }
  
}
