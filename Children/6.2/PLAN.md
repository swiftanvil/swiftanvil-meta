---
priority: HIGH
type: PLAN
audience: BUILDER
phase: 6
child: 6.2
last_updated: 2026-06-04
---

# Child 6.2 Plan: Documentation Generator CLI Integration

## Status

Planned.

## Goal

Close the AnvilDocs gap by integrating `AnvilDocs` into the CLI as `swiftanvil docs generate`.
Tag AnvilDocs `0.1.0` and make the documentation pipeline usable end-to-end.

## Scope

- Add `swiftanvil docs generate` command that:
  - Discovers DocC catalogs in a package or workspace.
  - Runs `swift build --target DocC` or `docc convert`.
  - Outputs static HTML to a configurable directory.
  - Supports `--hosting-base-path` for GitHub Pages.
- Add `swiftanvil docs preview` command that:
  - Starts a local HTTP server with the generated docs.
  - Watches for source changes and rebuilds.
- Tag `swiftanvil-anvil-docs` as `0.1.0`.
- Update `packages.registry` with the new version.
- Add CI workflow for docs generation validation.

## Non-Goals

- Do not build a custom DocC renderer (use Apple's `docc`).
- Do not host docs in this repo (GitHub Pages or external hosting only).
- Do not support multi-package combined docs in this child (deferred).
- Do not add `swiftanvil docs publish` (deferred to Child 6.3).

## Proposed Deliverables

| Deliverable | Repo | Notes |
|-------------|------|-------|
| `DocsGenerateCommand` | swiftanvil-cli | `swiftanvil docs generate` |
| `DocsPreviewCommand` | swiftanvil-cli | `swiftanvil docs preview` |
| `DocsCommand` (group) | swiftanvil-cli | ArgumentParser subcommand group |
| AnvilDocs `0.1.0` tag | swiftanvil-anvil-docs | First stable release |
| CI workflow for docs | swiftanvil-cli | Validates docs build on PRs |
| Updated README | swiftanvil-cli | Docs command usage |

## Command UX

### `swiftanvil docs generate`

```
$ swiftanvil docs generate --path ./MyPackage --output ./docs
Discovering DocC catalogs...
Found: MyPackage.docc
Building documentation...
✓ Generated 42 pages
Output: ./docs
```

Flags: `--path <dir>`, `--output <dir>`, `--hosting-base-path <path>`, `--target <name>`

### `swiftanvil docs preview`

```
$ swiftanvil docs preview --path ./MyPackage
Building documentation...
✓ Generated 42 pages
Preview: http://localhost:8080
Watching for changes...
```

Flags: `--port <n>`, `--path <dir>`, `--target <name>`

## Dependencies

- `planning.child-3.4` (Documentation Generator Recovery) — `AnvilDocs` package logic.
- `planning.child-5.3` (Release & Distribution) — tagging and CI patterns.

## Success Criteria

- [ ] `swiftanvil docs generate` produces valid static HTML from a DocC catalog.
- [ ] `swiftanvil docs preview` serves docs locally and rebuilds on change.
- [ ] AnvilDocs tagged `0.1.0` with changelog.
- [ ] Docs CI workflow passes on PRs.
- [ ] CLI README includes docs command examples.

## Review Plan

| Phase | Reviewer | Expected Focus |
|-------|----------|----------------|
| Plan | Cross-host agent | DocC integration approach, preview server design |
| Impl | Cross-host agent | End-to-end docs generation, error handling |

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| DocC not available in CI | Medium | Use `swift-docc-plugin` or skip docs step in CI |
| Preview server port conflicts | Low | Default to 8080, allow `--port` override |
| Large package docs slow to build | Medium | Add `--target` to scope generation |
