# Child 4.2 Plan: AnvilRunner 0.1 Release

## Status

Complete. This child backfills the AnvilRunner hardening and release work completed on 2026-06-04.

## Goal

Make `swiftanvil-anvil-runner` release-ready as the first external worker primitive for SwiftAnvil.

## Scope

- Harden runner lifecycle behavior.
- Improve cleanup safety and token handling.
- Add release hygiene files.
- Add local enforcement support.
- Add CI coverage across hosted macOS environments.
- Publish the first release tag.
- Document the managed worker direction without prematurely implementing provisioning.

## Non-Goals

- Do not make AnvilRunner install SSH, Tailscale, launch daemons, or power-management changes in the 0.1 release.
- Do not claim fleet management before capability discovery and doctor checks exist.
- Do not tie the runner to one local path or one developer machine.

## Deliverables

| Deliverable | Status |
|-------------|--------|
| Runner hardening PR | Complete |
| Release hygiene PR | Complete |
| Release metadata finalization | Complete |
| Tag and GitHub release | Complete |
| Managed worker vision document | Complete |

## Success Criteria

- Main branch CI passes.
- Release tag resolves to the merged main commit.
- Release notes explain the intended 0.1 scope.
- Future worker/provisioning work is assigned to later children.

## Review Provenance

Implementation review completed through independent review before merge. Release metadata review was also completed
before tagging.
