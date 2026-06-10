# Child 10.6 — TestFlight Pipeline: Result

## Status: Deferred ⏸️

## What Was Planned

### `swiftanvil distribute testflight`

Automated TestFlight upload pipeline: validate metadata, bump build number, archive, upload to App Store Connect, poll processing status.

## Why Deferred

This feature requires **App Store Connect API credentials** (Issuer ID, Key ID, private key `.p8` file) and **Xcode command-line tools** (`xcodebuild archive`, `altool`/`xcrun altool`). Without a real app and ASC account, the upload path cannot be validated end-to-end.

## Scaffold Created

The `DistributeCommand` structure in `swiftanvil-cli` is designed to accommodate this subcommand. Adding it requires:

1. `TestFlightSubmitter` actor wrapping ASC API JWT auth + upload
2. `BuildNumberBumper` to read/write `Info.plist` `CFBundleVersion`
3. Polling loop via `xcrun altool --validate-app` or ASC API

## Registry References

- `roadmap.org` — Phase 10 horizon 2
