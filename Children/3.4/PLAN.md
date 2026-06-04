# Child 3.4 Plan: Documentation Generator Recovery and Promotion

## Status

Complete.

## Reason

The roadmap previously marked Documentation Generator as complete, but the claimed repository did not exist in the
SwiftAnvil GitHub organization. The old local folder under the historical planning repository contained only a roadmap
file and a stale remote URL.

## Goal

Recover the intended documentation generator scope and either promote it into a real SwiftAnvil repository or revise
the roadmap if the implementation cannot be recovered.

## Scope

- Inspect the historical `iFoundation` documentation command and documentation-related source files.
- Determine whether the docs generator should be a standalone package, part of `swiftanvil-cli`, or deferred.
- Create `swiftanvil-anvil-docs` as a proper Swift package with source, tests, CI, README, roadmap, review artifacts,
  and enforcement.
- If part of CLI, create the corresponding CLI child/PR and update package registry references.
- Capture plan review and implementation review before marking complete.

## Non-Goals

- Do not claim completion from the historical roadmap alone.
- Do not create an empty repository just to satisfy the roadmap.
- Do not proceed to Phase 3.5 as complete until 3.4 has a real deliverable or an explicit de-scope decision.

## Success Criteria

- `roadmap.org` points to a real deliverable for documentation generation.
- The deliverable has passing CI and local enforcement.
- Review provenance is captured.
- `packages.registry` no longer lists a non-existent docs package as released.
- Phase 3 progress is updated honestly.

## Decision

AnvilDocs is a separate package. It owns reusable documentation registry load, validate, and compose logic.
`swiftanvil-cli` should own command-line UX in a later child.
