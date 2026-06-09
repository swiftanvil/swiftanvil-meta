# SwiftAnvil Organization Health Report

> Auto-generated report for the SwiftAnvil organization.
> **Generated**: 2026-06-05T21:40:57Z
> **Active Gate**: `improvement.dashboard` — PMS Improvement Sprint: AnvilMacros recovery
> **Roadmap Resume Point**: `planning.child-9-5` — finish workflow artifacts after PMS gate clears
> **Generator**: `script.org-report`

---

## Organization Overview

| Property | Value |
|----------|-------|
| **Organization** | [github.com/swiftanvil](https://github.com/swiftanvil) |
| **Total Repositories** | 17 |
| **Active Phase** | Phase 9 — iStudio Boundary & Tooling Expansion |
| **Current Health Gate** | PMS improvement sprint blocks lower-priority roadmap work |
| **Immediate Next Work** | Improve `swiftanvil-anvil-macros`: DocC catalog, CI workflow, git tag |
| **Current Roadmap Child** | 9.5 — Boundary Document & Enforcement (workflow incomplete) |
| **Next Roadmap Child** | 9.6 — Migrate iStudio Validators to SwiftAnvil |
| **Report Version** | 1 |

## Repository Health

| Repository | Status | Latest Release | CI Status | Tests | Last Updated |
|-----------|--------|---------------|-----------|-------|-------------|
| swiftanvil-anvil-a11y | stable |  | pending | 17/17 | 2026-06-04 |
| swiftanvil-anvil-bench | stable |  | pending | 77/77 | 2026-06-05 |
| swiftanvil-anvil-core | stable |  | pending | 11/11 | 2026-06-05 |
| swiftanvil-anvil-devmenu | stable |  | pending | 60/60 | 2026-06-05 |
| swiftanvil-anvil-docs | stable |  | pending | 6/6 | 2026-06-04 |
| swiftanvil-anvil-flags | stable |  | pending | 45/45 | 2026-06-05 |
| swiftanvil-anvil-macros | stable |  | pending | 12/12 | 2026-06-05 |
| swiftanvil-anvil-menubar | stable |  | pending | 13/13 | 2026-06-05 |
| swiftanvil-anvil-network | stable |  | pending | 31/31 | 2026-06-05 |
| swiftanvil-anvil-project | stable |  | pending | 37/37 | 2026-06-04 |
| swiftanvil-anvil-runner | stable | 0.1.0 | pending | CI passed for 0.2.0 | 2026-06-04 |
| swiftanvil-anvil-settings | stable |  | pending | 14/14 | 2026-06-05 |
| swiftanvil-anvil-strings | stable |  | pending | 21/21 | 2026-06-04 |
| swiftanvil-anvil-template | stable |  | pending | 30/30 | 2026-06-04 |
| swiftanvil-anvil-window | stable |  | pending | 12/12 | 2026-06-05 |
| swiftanvil-anvil-wizard | stable |  | pending | 20/20 | 2026-06-04 |
| swiftanvil-cli | stable |  | pending | 43 CLI + 7 lib + 5 CLI + 6 SwiftUI example tests | 2026-06-05 |

*CI Status: `success` = passing, `failure` = failing, `pending` = in progress, `unknown` = not available.*  
*Test counts from last verified build (see `roadmap.org`).*

## Phase Status

| Phase | Theme | Status | Progress |
|-------|-------|--------|----------|
| Phase 1 | Foundation | Complete | 5/5 |
| Phase 2 | Core Packages | Complete | 3/3 |
| Phase 3 | CLI & Integration | Complete | 5/5 |
| Phase 4 | Org Intelligence & Managed Workers | Complete | 5/5 |
| Phase 5 | Ecosystem & Distribution | Complete | 3/3 |
| Phase 6 | Integration & Validation | Complete | 3/3 |
| Phase 7 | Quality & Completeness | Complete | 7/7 |
| Phase 8 | macOS App Toolkit | Complete | 5/5 |
| Phase 9 | iStudio Boundary & Tooling Expansion | In Progress | 0/2 boundary children |
| Phase 10 | Future Expansion | Planned | 24 roadmap items |

## Active Health Gate

Per `meta.agents`, packages with PMS below 80 require an improvement sprint before lower-priority roadmap work.

| Package | PMS | Grade | Required Action |
|---------|-----|-------|-----------------|
| AnvilMacros | 58 | F | Add DocC catalog, CI workflow, git tag |
| AnvilCore | 65 | C | Tag v1.0.0 and add performance benchmarks |
| AnvilMenuBar | 65 | C | Tag v1.0.0 |
| AnvilSettings | 65 | C | Tag v1.0.0 |
| AnvilWindow | 65 | C | Tag v1.0.0 |

## Phase 9 Boundary Detail

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 9.5 | Boundary Document & Enforcement | Workflow incomplete: deliverables exist, review/result artifacts missing | swiftanvil-meta |
| 9.6 | Migrate iStudio Validators to SwiftAnvil | Planned; depends on 9.5 | swiftanvil-cli, iStudio |

## Review Provenance Summary

| Phase | Children | Cross-Host Reviewed | Self-Reviewed | Pending |
|-------|----------|---------------------|---------------|---------|
| Phase 1 | 5 | 4 | 1 (research) | 0 |
| Phase 2 | 3 | 3 | 0 | 0 |
| Phase 3 | 5 | 5 | 0 | 0 |
| Phase 4 | 5 | See child artifacts | 0 | 0 |
| Phase 5 | 3 | See child artifacts | 0 | 0 |
| Phase 6 | 3 | See child artifacts | 0 | 0 |
| Phase 7 | 7 | See child artifacts | 0 | 0 |
| Phase 8 | 5 | See child artifacts | 0 | 0 |
| Phase 9 boundary children | 2 | 0 | 0 | 1 (9.5 workflow artifacts) |
| **Current Gate** | **PMS sprint** | **Required before lower-priority work** | **0** | **1** |

*Self-reviewed children are documented per `workflow.orchestration` emergency procedure with all failed cross-host attempts recorded.*

## Registry Enforcement Status

| Check | Status | Last Run |
|-------|--------|----------|
| Document registry validation | Passing | 2026-06-05T21:40:57Z |
| Review artifact validation | Passing | 2026-06-05T21:40:57Z |

*Run locally via `swiftanvil-enforcement/scripts/enforce-local.sh`.*

## Next Work

| Priority | Child | Registry ID | Repo | Description |
|----------|-------|-------------|------|-------------|
| **1 (Next)** | PMS sprint | `improvement.dashboard` | swiftanvil-anvil-macros | Add DocC catalog, CI workflow, git tag; recalculate PMS |
| 2 | PMS sprint | `packages.registry` | AnvilCore/MenuBar/Settings/Window | Tag v1.0.0; add AnvilCore benchmarks |
| 3 | 9.5 | `planning.child-9-5` | swiftanvil-meta | Finish review, result, and provenance artifacts |
| 4 | 9.6 | `planning.child-9-6` | swiftanvil-cli, iStudio | Migrate Swift-specific validators to SwiftAnvil |

## Reserved Sections

> These sections are reserved for future roadmap children. Do not fill until the owning child completes.

### Validator Migration (TBD — Child 9.6)

- `swiftanvil lint source --structure`
- `.swiftanvil.yml` structure budget config
- iStudio pre-commit hook redirect to `swiftanvil lint source`

## Historical Note

The original planning for SwiftAnvil began in the `iFoundation` repository (archived at `~/Documents/v-i-s-h-a-l/github/iFoundation/`). All current planning lives in `swiftanvil-meta` as the organization source of truth. Historical children (1.1–3.3) were copied to `swiftanvil-meta/Children/` on 2026-06-04.

## Related Documents

| Document | Registry ID | Purpose |
|----------|-------------|---------|
| Roadmap | `roadmap.org` | Living project state |
| Children Index | `planning.children-index` | Phase child status |
| Improvement Dashboard | `improvement.dashboard` | Package scores and backlog |
| Package Registry | `packages.registry` | Detailed package status |
| Registry | `meta.registry` | All document IDs and paths |

---

*This report is generated by `script.org-report`. To regenerate: run the script from the repo root and commit the results.*
