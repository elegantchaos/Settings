# Settings

`Settings` defines canonical setting keys and typed access helpers so services and UI can read and write persisted preferences consistently.
Use it when a setting needs one shared key name, one default value, and typed access from both model code and SwiftUI.

## Usage

Define settings as static keys grouped by value type:

```swift
import Settings

extension AppSettingKey where Value == Bool {
  static let showDebug = AppSettingKey("showDebugOptions", defaultValue: false)
}

extension AppSettingKey where Value == String {
  static let selectedAccount = AppSettingKey("selectedAccount", defaultValue: "")
}
```

Read and write values through `UserDefaults` without repeating string keys:

```swift
let settings = UserDefaults.standard

let showDebug = settings.value(forKey: .showDebug)
settings.set(true, forKey: .showDebug)
```

Use the same key from SwiftUI with `@AppStorage`:

```swift
import SwiftUI
import Settings

struct DebugToggle: View {
  @AppStorage(.showDebug) private var showDebug

  var body: some View {
    Toggle("Show Debug Options", isOn: $showDebug)
  }
}
```

Raw-representable values are stored using their raw values:

```swift
enum RefreshMode: String {
  case automatic
  case manual
}

extension AppSettingKey where Value == RefreshMode {
  static let refreshMode = AppSettingKey("refreshMode", defaultValue: .automatic)
}

settings.set(RefreshMode.manual, forKey: .refreshMode)
let mode = settings.value(forKey: .refreshMode)
```

Capture and restore groups of values when tests or workflows need temporary settings:

```swift
let snapshot = settings.snapshot(for: .showDebug, .selectedAccount)

settings.set(false, forKey: .showDebug)
settings.set("octocat", forKey: .selectedAccount)

settings.restore(from: snapshot)
```

## Testing

`SettingsTestSupport` provides `TestSettings`, a `UserDefaults` that keeps its values in memory.
Give each test its own instance so that tests are isolated and leave nothing in the user's preferences:

```swift
import Settings
import SettingsTestSupport

let settings = TestSettings()
settings.set(true, forKey: .showDebug)
```

A real suite leaves a preferences file behind once it has been written to, even after `removePersistentDomain(forName:)`.
`TestSettings` sends no key-value observation notifications, and its registered defaults belong to the instance instead of the process. When a test needs a real suite, create it with a recognisable prefix so that the leftover files can be found and removed:

```swift
let settings = TestSettings.persistentSuite(prefix: "MyAppTests")
```
