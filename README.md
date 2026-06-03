# SwiftAnvil Meta

Shared operating memory, policies, roadmap, and workflow documentation for the SwiftAnvil organization.

This repository is not a product package. It exists so maintainers and LLM agents can use the same source of truth when planning, building, reviewing, upgrading, and releasing SwiftAnvil repositories.

## What Lives Here

| Path | Purpose |
|------|---------|
| `MEMORY/99-SESSION_START.md` | Required startup checklist for every agent session |
| `ROADMAP.md` | Current project phases and child work |
| `PLATFORM_POLICY.md` | Minimum platform and modernization policy |
| `PLATFORM_UPGRADE_PLAN.md` | Required upgrade sprint plan |
| `IMPROVEMENT_FRAMEWORK.md` | Package scoring and improvement workflow |
| `ORCHESTRATION_FRAMEWORK.md` | Plan, review, execute, verify, document workflow |
| `NAMING_REGISTRY.md` | Naming decisions and cleanup tracking |
| `API_MODERNIZATION.md` | Deprecated API cleanup tracking |

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

Every agent session should begin with:

```text
MEMORY/99-SESSION_START.md
```

That checklist points to the memory files that define current policy and priority. If a platform policy violation exists, the upgrade sprint takes priority over new feature work.

## Sharing Model

This repo should be hosted under the `swiftanvil` GitHub organization so organization members can use the same workflows with their own LLM agents. Private org visibility is appropriate while the project is still being shaped; public visibility can be revisited once the process is stable.
