# Initial project records

Date: 2026-10-02

Added and reviewed AGENTS.md for Settings, enabling a development journal and decision log. Committed the agreed agent guidance as `6aa6111`.

Backfilled three existing design choices with explicit user confirmation:

- [Canonical preference keys](../Decisions/0001-canonical-preference-keys.md): AppSettingKey defines a preference's name and default for UserDefaults and SwiftUI AppStorage.
- [Raw-value persistence](../Decisions/0002-raw-value-persistence.md): RawRepresentable preferences store their raw values and fall back to the key's default when conversion fails.
- [Isolated test settings](../Decisions/0003-isolated-test-settings.md): SettingsTestSupport provides in-memory settings, with explicitly named real suites for tests needing preferences-system behaviour.

These records describe the existing implementation; no source code changed. Checked the records against README.md and the relevant source files, then verified Markdown links and whitespace. Builds and tests were skipped for this documentation-only work.
