# Child 4.3 Plan: AnvilReport Organization Health Report

## Status

Planned Next

## Goal

Create a shared organization report that any SwiftAnvil contributor or agent can use to understand repository health, process compliance, release state, and next required work.

## Problem

The organization now has multiple repositories with related standards. Without a generated report, agents can miss which repo is current, which checks are required, which packages are below standard, and which phase child owns the next work.

## Scope

- Define the report contract in `swiftanvil-meta` first.
- Generate an initial human-readable org health report from known repository data.
- Track repository status, latest release, CI status where available, review provenance status, registry enforcement status, and open phase ownership.
- Make the report useful to any capable LLM agent, not only one named CLI.
- Keep the report driven from registry and package metadata where possible.

## Non-Goals

- Do not build a dashboard UI yet.
- Do not provision worker hosts in this child.
- Do not couple the report to one user's local folder layout.
- Do not require private repository access for public organization data.

## Report Schema (Draft v1)

The report has two artifacts: a human-readable Markdown report and a machine-readable YAML companion.

### Markdown Report (`ORG_REPORT.md`)

Sections:

| Section | Content | Source |
|---------|---------|--------|
| Header | Report title, generation date, next active child (registry ID) | Generated |
| Org Overview | Org name, total repos, active phase, last update | Generated |
| Repository Health | Table of all repos with status, latest release, CI, test count | Mixed (generated + hand-maintained) |
| Phase Status | Current phase, completed children, next child, blocked items | Generated from `ROADMAP.md` |
| Review Provenance | Summary of cross-host review coverage per child | Generated from `Children/*/REVIEW-PROVENANCE.md` |
| Registry Enforcement | Last enforcement run status, any failures | Generated from local enforcement |
| Next Work | Explicit next child with registry ID and repo | Generated from `Children/README.md` |
| Improvement Dashboard | Packages with PMS < 80, backlog items | Links to `improvement.dashboard` |

### YAML Companion (`ORG_REPORT.yml`)

```yaml
report:
  version: 1
  generated_at: "2026-06-04T00:00:00Z"
  generator: "scripts/generate-org-report.sh"
  next_active_child:
    id: "planning.child-4-3"
    name: "AnvilReport Organization Health Report"
    repo: "swiftanvil-meta"
    status: "in_progress"

repositories:
  - name: "swiftanvil-anvil-a11y"
    status: "stable"
    latest_release: "1.0.0"
    tests_passing: 17
    ci_status: "passing"
    last_updated: "2026-06-02"

phases:
  current: 4
  active_child: "4.3"
  completed_children: ["4.1", "4.2"]
  planned_children: ["4.4", "4.5"]

review_coverage:
  total_children: 15
  cross_host_reviewed: 14
  self_reviewed: 1
  pending_review: 0

enforcement:
  last_run: "2026-06-04T17:00:00Z"
  status: "passing"
  failures: []
```

## Deliverables & Registry IDs

| Deliverable | Path | Registry ID | Notes |
|-------------|------|-------------|-------|
| Report schema (this doc) | `Children/4.3/PLAN.md` | `planning.child-4-3` | Already registered |
| Human-readable report | `ORG_REPORT.md` | `report.org-health` | Generated, committed |
| Machine-readable report | `ORG_REPORT.yml` | `report.org-health-data` | Generated, committed |
| Generation script | `scripts/generate-org-report.sh` | `script.org-report` | Shell script |
| Plan review | `Children/4.3/REVIEW-PLAN.md` | `planning.child-4-3-review-plan` | This review |
| Result | `Children/4.3/RESULT.md` | `planning.child-4-3-result` | Post-execution |
| Review provenance | `Children/4.3/REVIEW-PROVENANCE.md` | `planning.child-4-3-provenance` | Post-execution |

## Task Breakdown

| # | Task | Estimate | Dependencies |
|---|------|----------|--------------|
| 1 | Write generation script (`scripts/generate-org-report.sh`) | 1 hour | None |
| 2 | Generate initial `ORG_REPORT.md` and `ORG_REPORT.yml` | 30 min | Task 1 |
| 3 | Register report docs in `REGISTRY.yml` | 15 min | Task 2 |
| 4 | Run local enforcement validation | 15 min | Task 3 |
| 5 | Write `Children/4.3/RESULT.md` | 30 min | Task 4 |
| 6 | Update `ROADMAP.md` with 4.3 status | 15 min | Task 5 |
| 7 | Commit and push | 15 min | Task 6 |

**Total estimate: ~3 hours**

## Success Criteria (Verifiable Checklist)

- [ ] `ORG_REPORT.md` exists at repo root and renders correctly on GitHub
- [ ] `ORG_REPORT.yml` exists at repo root and parses as valid YAML
- [ ] `scripts/generate-org-report.sh` exists and runs without errors
- [ ] Report names the next active child by registry ID (`planning.child-4-4` after this child completes)
- [ ] Report distinguishes historical iFoundation planning from current SwiftAnvil source of truth
- [ ] Report lists all 12 repos with status, release, and CI state
- [ ] Report shows AnvilRunner, enforcement, meta, and org profile status
- [ ] Report shows which next work belongs to AnvilReport (4.3), worker discovery (4.4), or provisioning (4.5)
- [ ] `swiftanvil-enforcement` registry validation passes (`scripts/validate-document-registry.sh`)
- [ ] `swiftanvil-enforcement` review provenance validation passes (`scripts/validate-review-artifacts.sh`)
- [ ] `planning.child-4-3-result` and `planning.child-4-3-provenance` are registered in `REGISTRY.yml`

## Relationship to Existing Docs

AnvilReport does **not** replace these docs — it **summarizes and links** to them:

| Existing Doc | Relationship |
|--------------|-------------|
| `ROADMAP.md` (`roadmap.org`) | Source of truth for phase status; report extracts and formats |
| `Children/README.md` (`planning.children-index`) | Source of truth for child status; report extracts |
| `IMPROVEMENT_DASHBOARD.md` (`improvement.dashboard`) | Report links to it for detailed PMS data |
| `MEMORY/07-PACKAGES.md` (`packages.registry`) | Report links to it for detailed package status |
| `REGISTRY.yml` (`meta.registry`) | Report uses registry IDs for all references |

## Risks

| Risk | Mitigation |
|------|-----------|
| Report becomes another stale document | Prefer generated fields and explicit last-verified dates; record source command per field |
| Registry friction | Register stable report IDs before other docs depend on paths |
| Scope creep into worker provisioning | Keep provisioning in Child 4.5; reserve placeholder sections in report |
| Duplication with existing docs | Explicitly link, don't duplicate; single source of truth remains in existing docs |

## Reserved Sections (for future children)

The report reserves these sections, marked TBD:

- **Worker Capabilities** — Filled by Child 4.4 (Managed Worker Capability Discovery)
- **Fleet Status** — Filled by Child 4.5 (Worker Provisioning and Fleet Profiles)

## Review Request Intention

The plan review should check whether this report is the right source of truth for multi-repo agents and whether the fields are sufficient to prevent scattered work.
