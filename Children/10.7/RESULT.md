# Child 10.7 — App Store Submission: Result

## Status: Deferred ⏸️

## What Was Planned

### `swiftanvil distribute appstore`

App Store submission automation: validate screenshots, check metadata completeness, submit for review, poll status.

## Why Deferred

This feature requires **App Store Connect API credentials** and a real app with complete App Store presence (screenshots, pricing, app review info). The submission API endpoints (`https://api.appstoreconnect.apple.com/v1/appStoreVersionSubmissions`) require a paid Apple Developer account.

## Scaffold Created

The `DistributeCommand` structure in `swiftanvil-cli` is designed to accommodate this subcommand. Adding it requires:

1. `AppStoreSubmitter` actor wrapping ASC API submission flow
2. Screenshot validation (count, dimensions, locale coverage)
3. Metadata completeness check against ASC API

## Registry References

- `roadmap.org` — Phase 10 horizon 2
