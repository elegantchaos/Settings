# Project Specific Rules

- This repository is a Swift package for canonical preference keys and typed UserDefaults and SwiftUI AppStorage access.
- Keep a development journal in `Extras/Journal/`.
- Keep a decision log in `Extras/Decisions/`.

# Standard Rules

1. Locate the shared agents content before starting work. Use `~/.local/share/agents/` when available; otherwise obtain it from https://github.com/elegantchaos/Agents.
2. You must read `COMMON.md` from that location before starting work, and follow the instructions in it at all times.
3. Resolve the skill names below from that same content, including skills provided by plugins.
4. For each skill required by the task, read its `SKILL.md` and follow its instructions, including any required supporting references.
5. Report any required guidance you cannot access.

- Follow the `baseline:standards` skill for all coding.
- Use the `baseline:records` skill for the development journal and decision log.
- Use the `codex-git` skill for git and GitHub operations.
- Use the `swift:language` skill for all Swift code.
- Also use the `swift:swiftui` skill for SwiftUI code.
- Also use the `swift:testing` skill for Swift Testing work.
- Also use the `swift:concurrency` skill for actor isolation and shared mutable state.

To refresh this file, use the `baseline:refresh` skill.
