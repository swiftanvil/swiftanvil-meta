# Child 4.3 Plan: AnvilReport Organization Health Report

## Status

Planned next.

## Goal

Create a shared organization report that any SwiftAnvil contributor or agent can use to understand repository health,
process compliance, release state, and next required work.

## Problem

The organization now has multiple repositories with related standards. Without a generated report, agents can miss
which repo is current, which checks are required, which packages are below standard, and which phase child owns the
next work.

## Scope

- Define the report contract in `swiftanvil-meta` first.
- Generate an initial human-readable org health report from known repository data.
- Track repository status, latest release, CI status where available, review provenance status, registry enforcement
  status, and open phase ownership.
- Make the report useful to any capable LLM agent, not only one named CLI.
- Keep the report driven from registry and package metadata where possible.

## Non-Goals

- Do not build a dashboard UI yet.
- Do not provision worker hosts in this child.
- Do not couple the report to one user's local folder layout.
- Do not require private repository access for public organization data.

## Proposed Deliverables

| Deliverable | Repo | Notes |
|-------------|------|-------|
| Report schema | swiftanvil-meta | Defines fields and meanings |
| Initial report document | swiftanvil-meta | Human and agent readable |
| Generation script or task plan | swiftanvil-meta | Can start manual-backed, then automate |
| Registry entries | swiftanvil-meta | Stable IDs for report docs |
| Review request | swiftanvil-meta | Plan review before implementation |

## Success Criteria

- A new agent can read the report and know the next phase child.
- The report distinguishes historical iFoundation planning from current SwiftAnvil source of truth.
- The report lists AnvilRunner, enforcement, meta, and org profile status.
- The report shows which next work belongs to AnvilReport, worker discovery, or provisioning.
- Enforcement passes locally.

## Risks

| Risk | Mitigation |
|------|------------|
| Report becomes another stale document | Prefer generated fields and explicit last-verified dates |
| Registry friction | Register stable report IDs before other docs depend on paths |
| Scope creep into worker provisioning | Keep provisioning in Child 4.5 |

## Review Request Intention

The plan review should check whether this report is the right source of truth for multi-repo agents and whether the
fields are sufficient to prevent scattered work.
