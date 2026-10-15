// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 28/01/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Marks primitive values supported by the typed UserDefaults setter.
public protocol SettingsCompatible {}

/// Supports storing string preferences through typed keys.
extension String: SettingsCompatible {}

/// Supports storing integer preferences through typed keys.
extension Int: SettingsCompatible {}

/// Supports storing floating-point preferences through typed keys.
extension Double: SettingsCompatible {}

/// Supports storing Boolean preferences through typed keys.
extension Bool: SettingsCompatible {}

/// A type-safe key for accessing UserDefaults values through AppStorage.
///
/// This type provides a strongly-typed wrapper around UserDefaults keys,
/// ensuring consistent key names and default values across the application.
public struct AppSettingKey<Value> {
  /// The string key used to store the value in UserDefaults.
  public let key: String

  /// The default value to use when no value is stored.
  public let defaultValue: Value

  /// Creates a new app setting key.
  /// - Parameters:
  ///   - key: The string key used in UserDefaults.
  ///   - defaultValue: The default value when no value is stored.
  public init(_ key: StringLiteralType, defaultValue: Value) {
    self.key = key
    self.defaultValue = defaultValue
  }

  /// Casts an untyped stored value to this key's value type without applying its default.
  public func typedValue(_ untyped: Any?) -> Value? {
    untyped as? Value
  }
}

/// Convenience construction for Boolean preference keys.
extension AppSettingKey where Value == Bool {
  /// Creates a Boolean key with a default of false unless specified.
  public init(_ key: StringLiteralType, defaultValue: Bool = false) {
    self.key = key
    self.defaultValue = defaultValue
  }
}

/// Construction for keys holding an existential raw-representable value.
extension AppSettingKey where Value == any RawRepresentable {
  /// Creates a key with the supplied raw-representable default.
  public init(_ key: StringLiteralType, defaultValue: Value) {
    self.key = key
    self.defaultValue = defaultValue
  }
}

/// Construction for keys whose value type is an enum's raw representation.
extension AppSettingKey {
  /// Creates a key using the supplied value's raw representation as its default.
  public init<T>(_ key: StringLiteralType, defaultValue: T)
  where T: RawRepresentable, T.RawValue == Value {
    self.key = key
    self.defaultValue = defaultValue.rawValue
  }
}
