# 0002 — Raw-value persistence

Status: Accepted
Date: 2026-10-02

Backfilled from the existing implementation and explicitly confirmed by the user on this date.

## Context

RawRepresentable preferences need a representation that UserDefaults can persist and a predictable response to absent or invalid stored values.

## Decision

Persist RawRepresentable preferences using their raw values. Typed UserDefaults reads reconstruct the value from its raw representation and return the AppSettingKey default when the stored value is absent, has the wrong type, or cannot be converted.

## Alternatives

Archiving the whole value and exposing conversion failures to every caller are rejected for these preferences. Raw-value persistence keeps the representation simple and centralises fallback behaviour. These alternatives are assessed during backfill; no earlier deliberation is asserted.

## Consequences

Raw values form the persisted representation. Renaming or removing a raw value can cause an existing preference to fall back to its default. The fallback does not itself rewrite the stored value.

## Evidence

- [README](../../README.md)
- [UserDefaults helpers](../../Sources/Settings/UserDefaults+AppSettingKey.swift)
- [AppStorage integration](../../Sources/Settings/AppStorage+AppSettingKey.swift)
