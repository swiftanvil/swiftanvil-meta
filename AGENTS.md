# Agent Instructions

## Purpose

This repository is the shared operating memory for SwiftAnvil. Treat it as the source of truth for planning, policy, package status, improvement scoring, and cross-repository workflow.

## Startup

Start every session by reading `meta.registry`, then resolve and read these document IDs:

1. `meta.session-start`
2. The document IDs referenced by that checklist
3. `roadmap.org`
4. `planning.children-index`
5. `agents.compatibility`
6. `agents.diagnostics` when reviewer or agent commands fail
7. `upgrade.platform` when platform violations are present

## Priority Rules

1. Platform policy violations block new feature work.
2. Packages with PMS below 80 require an improvement sprint before lower-priority work.
3. Roadmap child work proceeds only after active blockers are cleared.
4. Documentation and memory updates are part of completing work, not follow-up cleanup.

## Repository Boundaries

Do not place product package code in this repo. Product work belongs in the package repositories under the sibling SwiftAnvil workspace folder.

Expected local layout:

```text
<workspace>/
├── personal/
└── swiftanvil/
    ├── swiftanvil-meta/
    ├── swiftanvil-cli/
    ├── swiftanvil-anvil-template/
    ├── swiftanvil-anvil-docs/
    └── ...
```

## Editing Rules

- Keep memory files small and directly actionable.
- Use `meta.registry` document IDs in instructions, checklists, and code blocks.
- Keep instructions compatible with any capable LLM agent; do not require one named provider or CLI.
- Update `packages.registry` after package status, version, PMS, or platform changes.
- Update `modernization.api` when deprecated APIs are discovered or removed.
- Update `naming.registry` when package, module, product, or command names change.
- Keep roadmap status consistent; do not leave duplicate conflicting progress blocks.
