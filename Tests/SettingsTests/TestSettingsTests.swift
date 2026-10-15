// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 02/10/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ChaosTesting
import Foundation
import Settings
import Testing

/// Checks that typed setting keys work with ChaosTesting's in-memory test settings.
struct TestSettingsTests {
  /// Typed keys store and read their values through test settings.
  @Test func storesTypedSettingValues() {
    let settings = TestSettings()

    settings.set(TestEnum.b, forKey: .testEnum)
    settings.set(987, forKey: .testInt)

    #expect(settings.value(forKey: .testEnum) == .b)
    #expect(settings.value(forKey: .testInt) == 987)
    #expect(settings.hasKey(.testEnum))
  }
}

#if canImport(SwiftUI)
  import SwiftUI

  /// Checks that typed `@AppStorage` keys can use test settings as their store.
  struct TestSettingsAppStorageTests {
    /// A typed `@AppStorage` key reads and writes the test settings it is given.
    @Test func appStorageReadsAndWritesTestSettings() {
      let settings = TestSettings()
      @AppStorage(.testString, store: settings) var testString

      testString = "foo bar"

      #expect(testString == "foo bar")
      #expect(settings.value(forKey: .testString) == "foo bar")
    }
  }
#endif
