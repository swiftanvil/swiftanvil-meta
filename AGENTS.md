# Agent Instructions

## Purpose

This repository is the shared operating memory for SwiftAnvil. Treat it as the source of truth for planning, policy, package status, improvement scoring, and cross-repository workflow.

## Startup

Start every session by reading:

1. `MEMORY/99-SESSION_START.md`
2. The files referenced by that checklist
3. `ROADMAP.md`
4. `PLATFORM_UPGRADE_PLAN.md` when platform violations are present

## Priority Rules

1. Platform policy violations block new feature work.
2. Packages with PMS below 80 require an improvement sprint before lower-priority work.
3. Roadmap child work proceeds only after active blockers are cleared.
4. Documentation and memory updates are part of completing work, not follow-up cleanup.

## Repository Boundaries

Do not place product package code in this repo. Product work belongs in the package repositories under the sibling SwiftAnvil workspace folder.

Expected local layout:

```text
~/Documents/v-i-s-h-a-l/
├── github/
└── swiftanvil/
    ├── swiftanvil-meta/
    ├── swiftanvil-cli/
    ├── swiftanvil-anvil-template/
    ├── swiftanvil-anvil-docs/
    └── ...
```

## Editing Rules

- Keep memory files small and directly actionable.
- Update `MEMORY/07-PACKAGES.md` after package status, version, PMS, or platform changes.
- Update `API_MODERNIZATION.md` when deprecated APIs are discovered or removed.
- Update `NAMING_REGISTRY.md` when package, module, product, or command names change.
- Keep roadmap status consistent; do not leave duplicate conflicting progress blocks.
