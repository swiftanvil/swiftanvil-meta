# Child 10.8 — App Preview Generator: Result

## Status: Deferred ⏸️

## What Was Planned

### `swiftanvil distribute preview`

Auto-generate App Preview video from UI tests (screen recording + captions).

## Why Deferred

This feature requires **screen recording infrastructure** (Simulator video capture or device mirroring) and **video editing capabilities** (concatenation, caption overlay, export to App Store dimensions). These are substantial media pipeline features beyond the current CLI scope.

## Scaffold Created

The `DistributeCommand` structure in `swiftanvil-cli` is designed to accommodate this subcommand. Adding it requires:

1. `SimulatorRecorder` wrapping `xcrun simctl io booted recordVideo`
2. `VideoComposer` using `AVFoundation` to concatenate clips and add captions
3. App Store dimension validation (886×1920, 1920×886, etc.)

## Registry References

- `roadmap.org` — Phase 10 horizon 2
