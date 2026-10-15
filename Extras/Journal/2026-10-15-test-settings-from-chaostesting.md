# Test Settings From ChaosTesting

`TestSettings` moved to ChaosTesting, the shared package for test helpers, and
`SettingsTestSupport` was removed before v1.1.0 shipped. See
[Decision 0004](../Decisions/0004-test-settings-from-chaostesting.md).

- The test target depends on ChaosTesting 1.1.0 or later.
- The tests of `TestSettings` itself moved with it. Settings keeps the two that exercise its
  own typed keys and `@AppStorage` extension against test settings.
- AGENTS.md was refreshed from the shared baseline.
