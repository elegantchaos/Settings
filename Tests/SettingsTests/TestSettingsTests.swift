//
//  TestSettingsTests.swift
//  Settings
//
//  Created by Sam Deane on 02/10/2026.
//

import Foundation
import Settings
import SettingsTestSupport
import Testing

struct TestSettingsTests {
  @Test func storesTypedSettingValues() {
    let settings = TestSettings()

    settings.set(TestEnum.b, forKey: .testEnum)
    settings.set(987, forKey: .testInt)

    #expect(settings.value(forKey: .testEnum) == .b)
    #expect(settings.value(forKey: .testInt) == 987)
    #expect(settings.hasKey(.testEnum))
  }

  @Test func storesFoundationTypedValues() {
    let settings = TestSettings()

    settings.set(true, forKey: "flag")
    settings.set(42, forKey: "count")
    settings.set("name", forKey: "label")

    #expect(settings.bool(forKey: "flag"))
    #expect(settings.integer(forKey: "count") == 42)
    #expect(settings.string(forKey: "label") == "name")
  }

  @Test func removesValues() {
    let settings = TestSettings()
    settings.set("name", forKey: "label")

    settings.removeObject(forKey: "label")

    #expect(settings.object(forKey: "label") == nil)
  }

  @Test func isolatesInstances() {
    let first = TestSettings()
    let second = TestSettings()

    first.set("name", forKey: "label")

    #expect(second.object(forKey: "label") == nil)
  }

  /// Anything reaching the preferences system leaves a file behind, so nothing may reach it.
  @Test func writesNothingToThePreferencesSystem() throws {
    let settings = TestSettings()

    settings.set("name", forKey: "label")
    settings.set(true, forKey: "flag")

    let persisted = try #require(UserDefaults(suiteName: TestSettings.suiteName))
    #expect(persisted.persistentDomain(forName: TestSettings.suiteName) == nil)
  }

  @Test func persistentSuiteNamesStartWithThePrefix() throws {
    let name = TestSettings.persistentSuiteName(prefix: "ExampleTests")
    let other = TestSettings.persistentSuiteName(prefix: "ExampleTests")

    let suffix = try #require(name.split(separator: "-", maxSplits: 1).last)
    #expect(name.hasPrefix("ExampleTests-"))
    #expect(UUID(uuidString: String(suffix)) != nil)
    #expect(name != other)
  }

  @Test func persistentSuitesAreRealSuites() {
    let settings = TestSettings.persistentSuite(prefix: "SettingsTests")

    #expect(!(settings is TestSettings))
    #expect(settings.object(forKey: "label") == nil)
  }
}

#if canImport(SwiftUI)
  import SwiftUI

  struct TestSettingsAppStorageTests {
    @Test func appStorageReadsAndWritesTestSettings() {
      let settings = TestSettings()
      @AppStorage(.testString, store: settings) var testString

      testString = "foo bar"

      #expect(testString == "foo bar")
      #expect(settings.value(forKey: .testString) == "foo bar")
    }
  }
#endif
