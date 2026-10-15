# 0004 — Test settings from ChaosTesting

Status: Accepted
Date: 2026-10-15

Supersedes [0003](0003-isolated-test-settings.md).

## Context

Tests need independent settings without altering user preferences or leaving persistent suite files behind. Some tests need real preferences-system behaviour, including observation or domain handling.

`TestSettings` has nothing specific to Settings, and other Elegant Chaos packages need it too. ChaosTesting is the shared package for test helpers, with no dependencies of its own.

## Decision

Take `TestSettings` from ChaosTesting, as a dependency of the test target only. Settings does not ship a test-support library of its own; `SettingsTestSupport` is not part of any release.

Give each test its own in-memory instance. When a test requires real preferences-system behaviour, use a unique persistent suite with an explicit, recognisable prefix.

## Alternatives

Keeping `SettingsTestSupport` in Settings is rejected: packages that want in-memory settings without Settings itself would depend on Settings, or copy the type. Re-exporting ChaosTesting's type from `SettingsTestSupport` is rejected as an indirection layer with no behaviour of its own.

Using `UserDefaults.standard` or persistent suites for every test remains rejected as the default strategy because it introduces shared state or persistent files. Real suites remain available for tests requiring their behaviour.

## Consequences

Tests import ChaosTesting and inject `TestSettings` wherever a `UserDefaults` instance is accepted. Its stored values and registered defaults are instance-local, and changes send no key-value observation notifications. Tests using inherited domain or suite operations need the real preferences system. Persistent suite files can remain after the test; their prefixes make them identifiable for cleanup.

Consumers that imported `SettingsTestSupport` switch to ChaosTesting. Only the test target depends on ChaosTesting, so consumers of the `Settings` library do not resolve it.

## Evidence

- [README](../../README.md)
- [Package manifest](../../Package.swift)
- [ChaosTesting](https://github.com/elegantchaos/ChaosTesting)
