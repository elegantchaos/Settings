# 0001 — Canonical preference keys

Status: Accepted
Date: 2026-10-02

Backfilled from the existing implementation and explicitly confirmed by the user on this date.

## Context

Services and SwiftUI views need consistent preference names, types, and defaults. Repeating those definitions at each access site allows them to diverge.

## Decision

Use AppSettingKey as the canonical definition of each preference's name and default. UserDefaults access helpers and SwiftUI AppStorage initialisers consume the same typed key.

## Alternatives

Repeated string keys and defaults at each call site are rejected for this policy because they allow inconsistent definitions. This alternative is assessed during backfill; no earlier deliberation is asserted.

## Consequences

Define a preference once and reuse its key across service and UI access. Changes to a key's name or default affect all consumers and require review of persisted-value behaviour.

## Evidence

- [README](../../README.md)
- [AppSettingKey](../../Sources/Settings/AppSettingKey.swift)
- [UserDefaults helpers](../../Sources/Settings/UserDefaults+AppSettingKey.swift)
- [AppStorage integration](../../Sources/Settings/AppStorage+AppSettingKey.swift)
