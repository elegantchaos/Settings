# 0003 — Isolated test settings

Status: Accepted
Date: 2026-10-02

Backfilled from the existing implementation and explicitly confirmed by the user on this date.

## Context

Tests need independent settings without altering user preferences or leaving persistent suite files behind. Some tests need real preferences-system behaviour, including observation or domain handling.

## Decision

Provide TestSettings through the separate SettingsTestSupport library. Give each test its own in-memory instance. When a test requires real preferences-system behaviour, use a unique persistent suite with an explicit, recognisable prefix.

## Alternatives

Using UserDefaults.standard or persistent suites for every test is rejected as the default strategy because it introduces shared state or persistent files. Real suites remain available for tests requiring their behaviour. These alternatives are assessed during backfill; no earlier deliberation is asserted.

## Consequences

Tests can inject TestSettings wherever a UserDefaults instance is accepted. Its stored values and registered defaults are instance-local, and changes send no key-value observation notifications. Tests using inherited domain or suite operations need the real preferences system. Persistent suite files can remain after the test; their prefixes make them identifiable for cleanup.

## Evidence

- [README](../../README.md)
- [Package products](../../Package.swift)
- [TestSettings](../../Sources/SettingsTestSupport/TestSettings.swift)
