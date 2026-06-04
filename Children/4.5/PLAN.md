# Child 4.5 Plan: Worker Provisioning and Fleet Profiles

## Status

Planned.

## Goal

Allow AnvilRunner to help configure a Mac or worker host for SwiftAnvil jobs after discovery and doctor checks are
stable.

## Scope

- Define safe worker profiles for common roles.
- Add explicit, dry-run-first provisioning plans.
- Support SSH readiness checks and optional setup guidance.
- Support Tailscale readiness checks and optional setup guidance.
- Support macOS power-management guidance for restart-after-power-loss and remote access posture.
- Define fleet vocabulary for multiple workers without overbuilding a server.

## Non-Goals

- Do not perform privileged changes without explicit user consent.
- Do not store secrets in repository files.
- Do not require Tailscale or SSH for all users.
- Do not build full fleet orchestration until the single-host provisioning path is stable.

## Proposed Deliverables

| Deliverable | Repo | Notes |
|-------------|------|-------|
| Worker profile schema | swiftanvil-anvil-runner | Build, test, performance, review roles |
| Provisioning plan command | swiftanvil-anvil-runner | Dry-run by default |
| Safe apply mechanism | swiftanvil-anvil-runner | Explicit prompts and audit log |
| Fleet notes | swiftanvil-meta | Organization-level policy and future direction |

## Success Criteria

- A user can understand exactly what would change before applying anything.
- The tool supports self-hosted Mac runner use without forcing one network provider.
- The plan remains host-agnostic and reversible where possible.
- This work remains separate from the report and doctor children.
