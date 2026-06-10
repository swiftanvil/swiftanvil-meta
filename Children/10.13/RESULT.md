# Child 10.13 — Crash Symbolicator: Result

## Status: Deferred ⏸️

## What Was Planned

### `swiftanvil perf symbolicate`

Download dSYMs from App Store Connect, symbolicate crash logs, aggregate by module.

## Why Deferred

Requires **App Store Connect API credentials** to download dSYMs and **crash log files** to symbolicate. The symbolication pipeline (`atos`, `symbolicatecrash`) is complex and best implemented when there is a concrete crash analytics need.

## Registry References

- `roadmap.org` — Phase 10 horizon 3
