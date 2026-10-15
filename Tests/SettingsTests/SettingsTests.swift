// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/03/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ChaosTesting
import Foundation
import Settings
import Testing

/// String fixtures shared by the typed settings tests.
extension AppSettingKey where Value == String {
  /// A string preference with a nonempty default.
  static let testString = AppSettingKey("testString", defaultValue: "Hello, World!")
}

/// Integer fixtures shared by the typed settings tests.
extension AppSettingKey where Value == Int {
  /// An integer preference with a nonzero default.
  static let testInt = AppSettingKey("testInt", defaultValue: 123)
}

/// Floating-point fixtures shared by the typed settings tests.
extension AppSettingKey where Value == Double {
  /// A floating-point preference with a fractional default.
  static let testDouble = AppSettingKey("testDouble", defaultValue: 123.456)
}

/// Boolean fixtures shared by the typed settings tests.
extension AppSettingKey where Value == Bool {
  /// A Boolean preference that defaults to enabled.
  static let testBool = AppSettingKey("testBool", defaultValue: true)
}

/// Raw-representable fixtures shared by the typed settings tests.
extension AppSettingKey where Value == TestEnum {
  /// An enum preference whose default differs from the stored test value.
  static let testEnum = AppSettingKey("testEnum", defaultValue: .a)
}

/// Exercises enum preferences persisted as strings.
enum TestEnum: String {
  /// The default preference value.
  case a

  /// The alternative preference value used for writes.
  case b
}

/// Checks typed reads, writes, and defaults using a fresh in-memory store for each check.
struct SettingsTests {

  /// Checks that reading a persisted raw value reconstructs the expected enum value.
  func testRead<T>(key: AppSettingKey<T>, value testValue: T)
  where T: Equatable, T: RawRepresentable {
    let settings = TestSettings()
    settings.set(testValue.rawValue, forKey: key.key)
    let value = settings.value(forKey: key)
    #expect(value == testValue)
  }

  /// Checks that a stored primitive value can be read through its typed key.
  func testRead<T>(key: AppSettingKey<T>, value testValue: T)
  where T: Equatable, T: SettingsCompatible {
    let settings = TestSettings()
    settings.set(testValue, forKey: key)

    let value = settings.value(forKey: key)
    #expect(value == testValue)
  }

  /// Checks that an absent preference returns the key's declared default.
  func testReadDefault<T: Equatable>(key: AppSettingKey<T>) {
    let settings = TestSettings()

    let value = settings.value(forKey: key)
    #expect(value == key.defaultValue)
  }

  /// Checks that an enum write persists its raw representation.
  func testWrite<T: Equatable>(key: AppSettingKey<T>, value testValue: T)
  where T: Equatable, T: RawRepresentable {
    let settings = TestSettings()
    settings.set(testValue, forKey: key)
    let raw = settings.object(forKey: key.key) as? T.RawValue
    let value = raw.flatMap { T(rawValue: $0) }
    #expect(value == testValue)
  }

  /// Checks that a primitive write persists the expected value.
  func testWrite<T: Equatable>(key: AppSettingKey<T>, value testValue: T)
  where T: Equatable, T: SettingsCompatible {
    let settings = TestSettings()
    settings.set(testValue, forKey: key)
    let value = settings.object(forKey: key.key) as? T
    #expect(value == testValue)
  }

  /// Reads stored values for each supported fixture type.
  @Test func testRead() {
    testRead(key: .testString, value: "foo bar")
    testRead(key: .testInt, value: 987)
    testRead(key: .testDouble, value: 654.321)
    testRead(key: .testBool, value: true)
    testRead(key: .testEnum, value: .b)
  }

  /// Reads declared defaults for each supported fixture type.
  @Test func testDefault() {
    testReadDefault(key: .testString)
    testReadDefault(key: .testInt)
    testReadDefault(key: .testDouble)
    testReadDefault(key: .testBool)
    testReadDefault(key: .testEnum)
  }

  /// Writes primitive and enum values through typed keys.
  @Test func testWrite() {
    testWrite(key: .testString, value: "foo bar")
    testWrite(key: .testInt, value: 987)
    testWrite(key: .testDouble, value: 654.321)
    testWrite(key: .testBool, value: true)
    testWrite(key: .testEnum, value: .b)
  }

}

#if canImport(SwiftUI)
  import SwiftUI

  /// Checks that typed AppStorage wrappers read values and defaults from an injected store.
  struct SettingsAppStorageTests {
    /// Reads a stored string through its typed AppStorage key.
    @Test func testAppStorageString() {
      let settings = TestSettings()
      settings.set("foo bar", forKey: .testString)
      @AppStorage(.testString, store: settings) var testString
      #expect(testString == "foo bar")
      #expect(settings.string(forKey: "testString") == "foo bar")
    }

    /// Reconstructs a stored enum from its raw string value.
    @Test func testAppStorageEnum() {
      let settings = TestSettings()
      settings.set(TestEnum.b, forKey: .testEnum)
      @AppStorage(.testEnum, store: settings) var testEnum
      #expect(testEnum == .b)
      #expect(settings.string(forKey: "testEnum") == "b")
    }

    /// Uses the string key's default without persisting it.
    @Test func testAppStorageStringDefault() {
      let settings = TestSettings()
      @AppStorage(.testString, store: settings) var testString
      #expect(testString == AppSettingKey.testString.defaultValue)
      #expect(settings.object(forKey: "testString") == nil)
    }

    /// Uses the enum key's default without persisting it.
    @Test func testAppStorageEnumDefault() {
      let settings = TestSettings()
      @AppStorage(.testEnum, store: settings) var testEnum
      #expect(testEnum == .a)
      #expect(settings.object(forKey: "testEnum") == nil)
    }

  }
#endif

/// Checks snapshot restoration and equality across independent in-memory stores.
struct SnapshotTests {
  /// Restores captured string and integer values into a fresh store.
  @Test func testSnapshot() {
    let settings = TestSettings()
    settings.set("foo bar", forKey: .testString)
    settings.set(123, forKey: .testInt)

    let snapshot = settings.snapshot(for: .testString, .testInt)
    snapshot.print()

    let settings2 = TestSettings()
    settings2.restore(from: snapshot)

    #expect(settings2.value(forKey: .testString) == "foo bar")
    #expect(settings2.value(forKey: .testInt) == 123)
  }

  /// Compares snapshots using their captured typed values.
  @Test func testEquality() {
    let settings = TestSettings()
    settings.set("foo bar", forKey: .testString)
    settings.set(123, forKey: .testInt)

    let snapshot1 = settings.snapshot(for: .testString, .testInt)
    let snapshot2 = settings.snapshot(for: .testString, .testInt)
    #expect(snapshot1 == snapshot2)

    settings.set("bar foo", forKey: .testString)
    let snapshot4 = settings.snapshot(for: .testString, .testInt)
    #expect(snapshot1 != snapshot4)

  }
}
