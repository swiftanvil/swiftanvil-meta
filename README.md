# SwiftAnvil Meta

Shared operating memory, policies, roadmap, and workflow documentation for the SwiftAnvil organization.

This repository is not a product package. It exists so maintainers and LLM agents can use the same source of truth when planning, building, reviewing, upgrading, and releasing SwiftAnvil repositories.

## What Lives Here

All canonical document paths live in `meta.registry`. Other docs should refer to stable document IDs.

| Document ID | Purpose |
|-------------|---------|
| `meta.session-start` | Required startup checklist for every agent session |
| `roadmap.org` | Current project phases and child work |
| `policy.platform` | Minimum platform and modernization policy |
| `upgrade.platform` | Required upgrade sprint plan |
| `improvement.framework` | Package scoring and improvement workflow |
| `workflow.orchestration` | Plan, review, execute, verify, document workflow |
| `naming.registry` | Naming decisions and cleanup tracking |
| `modernization.api` | Deprecated API cleanup tracking |

## Standard Workspace Layout

The local workspace should keep personal repositories and organization repositories separate:

```text
~/Documents/v-i-s-h-a-l/
├── github/       # personal repositories for now
└── swiftanvil/   # SwiftAnvil organization repositories
    ├── swiftanvil-meta/
    ├── swiftanvil-cli/
    ├── swiftanvil-anvil-template/
    └── ...
```

The `github` folder name is historical and may be renamed later. Do not rely on it as the organization boundary.

## Agent Startup

Every agent session should resolve `meta.session-start` from `meta.registry` and begin there.

That checklist points to the memory files that define current policy and priority. If a platform policy violation exists, the upgrade sprint takes priority over new feature work.

## Sharing Model

This repo should be hosted under the `swiftanvil` GitHub organization so organization members can use the same workflows with their own LLM agents. Private org visibility is appropriate while the project is still being shaped; public visibility can be revisited once the process is stable.
