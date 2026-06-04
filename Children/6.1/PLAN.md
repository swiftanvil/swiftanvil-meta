---
priority: HIGH
type: PLAN
audience: BUILDER
phase: 6
child: 6.1
last_updated: 2026-06-04
---

# Child 6.1 Plan: CLI Integration — Templates & Plugins

## Status

Planned.

## Goal

Make the Phase 5 infrastructure actually usable from the CLI. Wire `TemplateInstaller` and `PluginRegistry`
into real `swiftanvil` subcommands so users can list, install, and manage templates and plugins without
writing Swift code.

## Scope

- Add `swiftanvil template list` — fetch registry, print formatted table, respect cache/offline flags.
- Add `swiftanvil template install <name>` — download, validate, substitute variables, install atomically.
- Add `swiftanvil plugin list` — list registered plugins (built-in + compile-time dependencies).
- Add `swiftanvil plugin info <identifier>` — show plugin metadata, commands, generators, hooks.
- Integrate `AnvilWizard` for interactive variable prompts during template install.
- Integrate `AnvilTemplate` for variable substitution in installed templates.
- Add `--force`, `--refresh`, `--offline`, `--output <dir>` flags.

## Non-Goals

- Do not add runtime plugin downloading (still compile-time only per Child 5.2).
- Do not build a plugin marketplace or template rating system.
- Do not support template uninstall in this child (deferred).
- Do not add `swiftanvil docs` command (deferred to Child 6.2).

## Proposed Deliverables

| Deliverable | Repo | Notes |
|-------------|------|-------|
| `TemplateListCommand` | swiftanvil-cli | `swiftanvil template list` |
| `TemplateInstallCommand` | swiftanvil-cli | `swiftanvil template install <name>` |
| `PluginListCommand` | swiftanvil-cli | `swiftanvil plugin list` |
| `PluginInfoCommand` | swiftanvil-cli | `swiftanvil plugin info <id>` |
| `TemplateCommand` (group) | swiftanvil-cli | ArgumentParser subcommand group |
| `PluginCommand` (group) | swiftanvil-cli | ArgumentParser subcommand group |
| CLI integration tests | swiftanvil-cli | Mock registry, mock file system, InMemoryFileSystem |
| Updated README | swiftanvil-cli | Usage examples for new commands |

## Command UX

### `swiftanvil template list`

```
$ swiftanvil template list
Name           Description                        Author        Platforms
───            ───────────                        ──────        ─────────
swiftui-app    A SwiftUI iOS app with navigation  swiftanvil    iOS, macOS, visionOS
cli-tool       A command-line tool with args      swiftanvil    macOS
library        SPM library with DocC setup        swiftanvil    All

3 templates available. Cache expires in 42 minutes.
Use --refresh to update now.
```

Flags: `--refresh`, `--offline`, `--json`

### `swiftanvil template install <name>`

```
$ swiftanvil template install swiftui-app
Project name [SwiftUIApp]: MyApp
Include test target? [Y/n]: y
Navigation style [stack/tab/split] [stack]: tab
Installing swiftui-app v1.0.0...
✓ Package.swift
✓ Sources/App/App.swift
✓ Tests/AppTests/AppTests.swift
Installed to ./MyApp
Run: cd MyApp && swift build
```

Flags: `--force`, `--output <dir>`, `--offline`, `--refresh`

### `swiftanvil plugin list`

```
$ swiftanvil plugin list
ID                           Name        Version  Commands
──                           ────        ───────  ────────
com.swiftanvil.builtin       Built-in    0.3.0    generate, verify, template, plugin
```

Flags: `--json`

### `swiftanvil plugin info <identifier>`

```
$ swiftanvil plugin info com.swiftanvil.builtin
Name: Built-in
Version: 0.3.0
Commands:
  generate    Generate a new project
  verify      Verify a generated project
  template    Template management commands
  plugin      Plugin management commands
```

## Dependencies

- `planning.child-5.1` (Community Templates) — `TemplateRegistry`, `TemplateInstaller`, `TemplateManifest`.
- `planning.child-5.2` (Plugin System) — `PluginRegistry`, `SwiftAnvilPlugin` protocol.
- `planning.child-3.1` (Wizard System) — interactive prompts for template variables.
- `planning.child-3.2` (Template Engine) — variable substitution in installed files.
- `planning.child-3.3` (Project Generator) — `FileSystem` protocol for testability.

## Success Criteria

- [ ] `swiftanvil template list` prints a formatted table with ≥ 3 templates.
- [ ] `swiftanvil template install swiftui-app` creates a buildable project with interactive prompts.
- [ ] `--offline` uses cached registry; `--refresh` bypasses cache.
- [ ] `--force` overwrites existing directory.
- [ ] `--json` outputs machine-readable JSON for `list` and `info` commands.
- [ ] `swiftanvil plugin list` shows all registered plugins.
- [ ] `swiftanvil plugin info` shows commands, generators, and hooks per plugin.
- [ ] All new commands have integration tests with `InMemoryFileSystem`.
- [ ] Test coverage ≥ 80% for new command code.
- [ ] CLI README updated with usage examples.

## Review Plan

| Phase | Reviewer | Expected Focus |
|-------|----------|----------------|
| Plan | Cross-host agent | Command UX consistency, flag design, test strategy |
| Impl | Cross-host agent | End-to-end command tests, error handling, help text |

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| ArgumentParser version conflicts | Low | Pin version in Package.swift |
| Network flakes in tests | Medium | Mock registry fetcher; no real network in tests |
| Template variable prompts break CI | Low | `--non-interactive` flag with `--var key=value` |
| Plugin list is empty (no plugins yet) | Medium | Show built-in commands as a pseudo-plugin |
