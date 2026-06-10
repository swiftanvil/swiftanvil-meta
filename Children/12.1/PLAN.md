# Phase 12.1 — Machine-Readable CLI Output

> Child of Phase 12: Agent-Native CLI
> Parent: `roadmap.org`
> Status: Planning

---

## Objective

Add `--json` output support to every existing `swiftanvil` CLI command so that AI agents and programmatic consumers can reliably consume CLI output without parsing human-formatted text.

This child closes **Gap 1** identified in `review.ai-agent-ecosystem` and unblocks every downstream integration (iStudio, CI gates, agent context generation).

---

## Background

Every `swiftanvil` command today prints human-formatted text. Examples:

```
swiftanvil lint source --structure
/path/to/File.swift
  Lines: 234/350 ✓
  Top-level types: 3/4 ✓
  Mixed type kinds: 2/3 (warning)
```

AI agents must parse this with regex or heuristics — fragile and error-prone. A `--json` flag makes consumption trivial and reliable.

---

## Scope

### In Scope

| Command | JSON Output |
|---------|-------------|
| `swiftanvil create` | `{ success, path, filesGenerated[] }` |
| `swiftanvil adopt` | `{ success, filesModified[] }` |
| `swiftanvil lint package` | `{ violations[], summary }` |
| `swiftanvil lint source` | `{ files[], violations[], summary }` |
| `swiftanvil lint tests` | `{ violations[], summary }` |
| `swiftanvil lint deps` | `{ violations[], summary }` |
| `swiftanvil doctor` | `{ checks[], overallStatus }` |
| `swiftanvil docs generate` | `{ success, outputPath }` |
| `swiftanvil docs preview` | `{ url, pid }` |
| `swiftanvil docs validate` | `{ violations[], summary }` |
| `swiftanvil immunity scan` | `{ anomalies[], summary }` |
| `swiftanvil verify` | `{ success, checks[] }` |
| `swiftanvil health scan` | `{ dimensions[], overall }` |

### Out of Scope

- New commands (those come in Child 12.2: `swiftanvil agent context`)
- MCP server (Child 12.4)
- `SwiftAnvilArtifact` schema definition (Child 12.3)

---

## Design

### JSON Schema v1

Every command emits a top-level object with these common fields:

```json
{
  "version": 1,
  "command": "lint source",
  "timestamp": "2026-06-10T12:00:00Z",
  "success": true,
  "data": { ... command-specific ... }
}
```

On failure:

```json
{
  "version": 1,
  "command": "lint source",
  "timestamp": "2026-06-10T12:00:00Z",
  "success": false,
  "error": {
    "code": "LINT_ERROR",
    "message": "Failed to parse Package.swift"
  }
}
```

### Implementation Strategy

1. **Add `JSONOutputFormatter`** — a protocol and concrete type in `swiftanvil-cli`:
   ```swift
   protocol OutputFormatter {
     func write<T: Encodable>(_ value: T)
     func writeError(_ error: Error)
   }
   struct JSONOutputFormatter: OutputFormatter { ... }
   struct HumanOutputFormatter: OutputFormatter { ... }
   ```

2. **Thread formatter through commands** — each command gets an `OutputFormatter` injected. Default is `HumanOutputFormatter`. `--json` switches to `JSONOutputFormatter`.

3. **Define Codable response types** — one per command domain, living alongside the command implementation.

4. **Stdout only** — JSON goes to stdout. Human-readable progress/logs go to stderr (already the case for most commands).

5. **Streaming** — for long-running commands, emit NDJSON (newline-delimited JSON) with a `type` discriminator:
   ```json
   {"type":"progress","message":"Scanning 45 files..."}
   {"type":"result","data":{...}}
   ```

---

## Files to Modify

| File | Change |
|------|--------|
| `Sources/SwiftAnvilCLI/Commands/CreateCommand.swift` | Add `--json`, emit `CreateResult` |
| `Sources/SwiftAnvilCLI/Commands/AdoptCommand.swift` | Add `--json`, emit `AdoptResult` |
| `Sources/SwiftAnvilCLI/Commands/LintCommand.swift` | Add `--json`, emit `LintResult` |
| `Sources/SwiftAnvilCLI/Commands/DoctorCommand.swift` | Add `--json`, emit `DoctorResult` |
| `Sources/SwiftAnvilCLI/Commands/DocsCommand.swift` | Add `--json`, emit `DocsResult` |
| `Sources/SwiftAnvilCLI/Commands/ImmunityCommand.swift` | Add `--json`, emit `ImmunityResult` |
| `Sources/SwiftAnvilCLI/Commands/VerifyCommand.swift` | Add `--json`, emit `VerifyResult` |
| `Sources/SwiftAnvilCLI/Commands/HealthCommand.swift` | Add `--json`, emit `HealthResult` |
| `Sources/SwiftAnvilCLI/Formatting/OutputFormatter.swift` | New file: protocol + formatters |
| `Sources/SwiftAnvilCLI/Formatting/JSONTypes.swift` | New file: shared Codable types |
| `Tests/SwiftAnvilCLITests/JSONOutputTests.swift` | New file: fixture-based tests |

---

## Testing Plan

1. **Unit tests** — For each command, test that `--json` produces valid JSON matching the schema.
2. **Fixture tests** — Snapshot test JSON output for representative inputs.
3. **Regression tests** — Ensure human output is unchanged when `--json` is absent.
4. **Integration tests** — Pipe `--json` output to `jq` in CI to validate schema compliance.

---

## Acceptance Criteria

- [ ] All 12 commands above support `--json`
- [ ] `swiftanvil <command> --json | jq .` succeeds for every command
- [ ] Human output is unchanged when `--json` is omitted
- [ ] JSON schema version is documented in `meta.registry`
- [ ] Tests added: ≥1 per command (≥12 new tests)
- [ ] `swift test` passes (113 + new tests)

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Large refactor touching many files | Incremental: one command per commit, feature flag off by default until complete |
| Breaking scripts that parse human output | Human output is unchanged; `--json` is opt-in |
| JSON schema churn | Version field in output; v1 is minimal and stable |

---

## Dependencies

- None. This child is self-contained within `swiftanvil-cli`.

---

## Estimated Effort

Medium — 1–2 sessions for implementation, 1 session for tests and review.

---

## Next Child

Child 12.2: `swiftanvil agent context` — builds on `--json` to generate bounded context packets for AI agents.
