---
priority: HIGH
type: PLAN
audience: BUILDER
phase: 5
child: 5.1
last_updated: 2026-06-04
---

# Child 5.1 Plan: Community Templates

## Status

Planned. Revised per cross-host review (APPROVED_WITH_NOTES).

## Goal

Create a community-contributed template gallery for `swiftanvil` CLI users. Users should be able to discover,
install, and use templates beyond the built-in library/executable/test types.

## Scope

- Define a template manifest format (metadata + file list + variables + security constraints).
- Create a versioned template registry (JSON) that lists available community templates.
- Add `swiftanvil template list` and `swiftanvil template install <name>` commands to the CLI.
- Host 3 official templates as examples (SwiftUI app, CLI tool, SPM library with DocC).
- Document how community members contribute new templates.

## Non-Goals

- Do not build a full package manager (no dependency resolution, no versioning beyond tags).
- Do not host templates in this repo — each template is its own repo under `swiftanvil`.
- Do not require authentication for template discovery (public read).
- Do not support `postInstall` scripts in this iteration (deferred to Child 5.2 plugin system).

## Proposed Deliverables

| Deliverable | Repo | Notes |
|-------------|------|-------|
| `TemplateManifest` — `Sendable` struct | swiftanvil-anvil-template | Parses and validates manifest YAML/JSON |
| `TemplateRegistry` — `Sendable` struct | swiftanvil-anvil-template | Parses registry JSON, supports caching |
| `TemplateInstaller` — `Sendable` actor | swiftanvil-anvil-template | Downloads, validates, installs with rollback |
| `TemplateInstallError` enum | swiftanvil-anvil-template | Network, validation, path traversal, platform, overwrite |
| Template registry JSON | swiftanvil-meta | Curated list of official + community templates |
| `template list` command | swiftanvil-cli | Fetches registry (with cache), prints table |
| `template install` command | swiftanvil-cli | Downloads template, validates manifest, copies files safely |
| Official example templates | New repos under swiftanvil | `swiftanvil-template-swiftui`, `swiftanvil-template-cli`, `swiftanvil-template-library` |
| Contributor docs | swiftanvil-meta | `Children/5.1/CONTRIBUTING_TEMPLATES.md` |
| Tests | swiftanvil-anvil-template | `TemplateManifestTests`, `TemplateRegistryTests`, `TemplateInstallTests` |

## Dependencies

- `planning.child-3.1` (Wizard System) — interactive prompts for install confirmation and variable input.
- `planning.child-3.2` (Template Engine) — variable substitution in installed templates.
- `planning.child-3.3` (Project Generator) — generating from an external template spec, `FileSystem` protocol pattern.

## Template Manifest Schema (v1)

```yaml
manifestVersion: 1
name: swiftui-app
version: 1.0.0
swiftToolsVersion: "6.0"
minimumSwiftanvilVersion: "1.0.0"
description: A SwiftUI iOS app with modern navigation
author: swiftanvil
license: MIT
platforms:
  - iOS 18+
  - macOS 15+
  - tvOS 18+
  - watchOS 11+
  - visionOS 2+
tags:
  - ios
  - swiftui
  - app
files:
  - source: Package.swift
    destination: Package.swift
  - source: Sources/App/App.swift
    destination: Sources/App/App.swift
    platforms: [iOS, macOS, visionOS]
  - source: Sources/App/TVApp.swift
    destination: Sources/App/App.swift
    platforms: [tvOS]
exclude:
  - .git
  - .github
  - README-assets
variables:
  - name: projectName
    type: string
    prompt: "Project name"
    default: "SwiftUIApp"
  - name: includeTests
    type: bool
    prompt: "Include test target?"
    default: true
  - name: navigationStyle
    type: choice
    prompt: "Navigation style"
    choices: [stack, tab, split]
    default: stack
```

### Manifest Field Rules

| Field | Required | Type | Validation |
|-------|----------|------|------------|
| `manifestVersion` | Yes | Int | Must be `1` |
| `name` | Yes | String | Lowercase alphanumeric + hyphens. Max 50 chars. |
| `version` | Yes | String | Valid SemVer |
| `swiftToolsVersion` | Yes | String | Valid Swift tools version (e.g. `"6.0"`) |
| `minimumSwiftanvilVersion` | Yes | String | Valid SemVer |
| `description` | Yes | String | Max 200 chars |
| `author` | Yes | String | Max 100 chars |
| `license` | Yes | String | SPDX identifier or "Proprietary" |
| `platforms` | Yes | [String] | Subset of SwiftAnvil platform policy |
| `tags` | No | [String] | Max 10 tags, each max 20 chars |
| `files` | Yes | [FileEntry] | At least one entry |
| `exclude` | No | [String] | Glob patterns |
| `variables` | No | [Variable] | Names must be valid Swift identifiers |

### FileEntry

```yaml
source: String        # Path within template repo
destination: String   # Path in user's project
platforms: [String]?  # Optional platform filter
```

### Variable

```yaml
name: String
prompt: String
default: Any?         # Type matches `type`
type: string | int | bool | choice
choices: [String]?    # Required when type == choice
```

## Registry Format

```json
{
  "registryVersion": 1,
  "lastUpdated": "2026-06-04T12:00:00Z",
  "templates": [
    {
      "name": "swiftui-app",
      "version": "1.0.0",
      "description": "A SwiftUI iOS app with modern navigation",
      "author": "swiftanvil",
      "license": "MIT",
      "platforms": ["iOS 18+", "macOS 15+"],
      "tags": ["ios", "swiftui"],
      "source": {
        "type": "git",
        "url": "https://github.com/swiftanvil/swiftanvil-template-swiftui",
        "tag": "1.0.0"
      },
      "manifestSHA256": "abc123..."
    }
  ]
}
```

## Install Behavior

1. **Discovery**: CLI fetches registry from `swiftanvil-meta` (cached at `~/.swiftanvil/registry.json`, TTL 1 hour).
2. **Selection**: User runs `swiftanvil template install swiftui-app`.
3. **Download**: CLI clones or downloads tarball from registry `source.url` at `source.tag`.
4. **Validation**: Parse `anvil-template.yml`, validate against schema v1, verify `manifestSHA256`.
5. **Platform check**: Verify host supports template's `platforms`.
6. **Variables**: Prompt user for variables (via AnvilWizard), apply defaults.
7. **Copy**: For each `FileEntry`, copy `source` → `destination` with variable substitution.
   - Reject `destination` containing `..` or absolute paths (path traversal protection).
   - Skip files where `platforms` does not match host.
   - Skip files matching `exclude` patterns.
   - Default: fail if destination exists. Use `--force` to overwrite.
8. **Atomicity**: Write to temp directory, then atomic move. Rollback on any failure.
9. **Result**: Print installed files, next steps.

## Security Requirements

- Path traversal: Reject any `destination` containing `..` or starting with `/`.
- Overwrite: Default to fail; require `--force` flag.
- Integrity: Registry entries include `manifestSHA256`; CLI verifies after download.
- Reproducibility: Install from pinned `tag` or `commitSHA`, not floating branch.
- No arbitrary code execution: No `postInstall` scripts in v1.

## Success Criteria

- [ ] `swiftanvil template list` prints a table with name, description, author, platforms (≥ 3 official templates visible).
- [ ] `swiftanvil template install swiftui-app` creates a buildable Swift project in a new subdirectory.
- [ ] `TemplateManifest` parses and validates all v1 schema rules; invalid manifests produce clear errors.
- [ ] Path traversal attempts are rejected with `TemplateInstallError.pathTraversalDetected`.
- [ ] Overwrite without `--force` fails with `TemplateInstallError.destinationExists`.
- [ ] Registry cache respects TTL; `--refresh` bypasses; `--offline` uses cache only.
- [ ] All official templates build successfully with `swift build` after installation.
- [ ] Test coverage ≥ 80% for `TemplateManifest`, `TemplateRegistry`, `TemplateInstaller`.
- [ ] `CONTRIBUTING_TEMPLATES.md` enables a new contributor to submit a PR without asking for help.

## Review Plan

| Phase | Reviewer | Expected Focus |
|-------|----------|----------------|
| Plan | Cross-host agent (Claude) | Schema completeness, registry design, security of install path |
| Impl | Cross-host agent | Command UX, manifest validation, error handling, test coverage |

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Template repos drift out of date | High | CI cron job to validate templates against latest Swift |
| Malicious template submissions | Low | Registry is curated; community submissions need PR review; SHA-256 verification |
| Manifest schema changes break old templates | Medium | Version the schema; CLI supports multiple manifest versions |
| Network failures during install | Medium | Clear error messages; retry with exponential backoff; offline cache |
