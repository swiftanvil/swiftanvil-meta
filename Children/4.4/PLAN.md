# Child 4.4 Plan: Managed Worker Capability Discovery and Doctor

## Status

Planned

## Goal

Teach AnvilRunner how to describe what a host can do and how healthy it is, without making privileged changes.

## Problem

Before provisioning workers (Child 4.5), we need to know what a host is capable of. Without a standardized discovery and doctor mechanism, provisioning decisions are guesswork. Agents need to know: can this host build Swift? Run tests? Host a review? Is its toolchain current?

## Scope

- Define a capability model for a worker host.
- Add a read-only `discover` command.
- Add a `doctor` command that reports missing or degraded capabilities.
- Detect installed developer tools, Swift/Xcode versions, common agent CLIs, authentication readiness where safe, SSH reachability state, Tailscale availability, and power-management posture.
- Support JSON output for automation and readable output for humans.
- Produce output that fills the "Worker Capabilities" reserved section in `report.org-health`.

## Non-Goals

- Do not install or configure Tailscale, SSH, Xcode, agents, or power settings in this child.
- Do not assume tools live in one fixed path.
- Do not require paid access to any optional LLM provider.
- Do not expose secrets in report output.

## Capability Schema (Draft v1)

The discovery/doctor output is a JSON document with this structure:

```json
{
  "schema_version": 1,
  "generated_at": "2026-06-04T12:00:00Z",
  "host": {
    "platform": "macOS",
    "platform_version": "15.5",
    "architecture": "arm64",
    "hostname": "worker-01"
  },
  "capabilities": {
    "swift": {
      "installed": true,
      "version": "6.0.3",
      "path": "/usr/bin/swift"
    },
    "xcode": {
      "installed": true,
      "version": "16.2",
      "path": "/Applications/Xcode.app"
    },
    "git": {
      "installed": true,
      "version": "2.47.0"
    },
    "github_cli": {
      "installed": true,
      "version": "2.67.0",
      "authenticated": true
    }
  },
  "agents": {
    "claude": {
      "installed": true,
      "version": "2.1.152",
      "authenticated": true
    },
    "codex": {
      "installed": false
    },
    "gemini": {
      "installed": false
    }
  },
  "network": {
    "ssh": {
      "installed": true,
      "reachable": true,
      "key_configured": true
    },
    "tailscale": {
      "installed": true,
      "running": true,
      "logged_in": true
    }
  },
  "power": {
    "prevent_sleep": false,
    "on_ac_power": true
  },
  "checks": [
    {
      "id": "swift-installed",
      "category": "toolchain",
      "status": "pass",
      "message": "Swift 6.0.3 installed at /usr/bin/swift"
    },
    {
      "id": "codex-available",
      "category": "agent",
      "status": "warn",
      "message": "Codex CLI not installed (optional)"
    }
  ]
}
```

### Check Status Values

| Status | Meaning | Doctor Exit Code |
|--------|---------|-----------------|
| `pass` | Capability present and healthy | 0 |
| `warn` | Optional capability missing or degraded | 0 |
| `fail` | Required capability missing or broken | 1 |

## CLI Commands

| Command | Purpose | Output |
|---------|---------|--------|
| `anvil-runner discover [--json]` | Read-only host capability scan | Human table or JSON |
| `anvil-runner doctor [--json]` | Health check with pass/warn/fail | Human table or JSON |

Both commands are read-only. Neither modifies the host.

### Safe Auth Probes

| CLI | Safe Probe | Unsafe (avoid) |
|-----|-----------|----------------|
| `claude` | `claude --version` | Any network call |
| `codex` | `codex --version` | Any network call |
| `gemini` | `gemini --version` | Any network call |
| `gh` | `gh auth status` (local-only check) | `gh api` calls |

Auth readiness is determined by checking local config files and running `--version`, never by making network requests.

## Deliverables & Registry IDs

| Deliverable | Path | Registry ID | Notes |
|-------------|------|-------------|-------|
| Capability schema (this doc) | `Children/4.4/PLAN.md` | `planning.child-4-4` | Already registered |
| Discovery command | `swiftanvil-anvil-runner/Sources/...` | N/A (product code) | `anvil-runner discover` |
| Doctor command | `swiftanvil-anvil-runner/Sources/...` | N/A (product code) | `anvil-runner doctor` |
| Capability types | `swiftanvil-anvil-runner/Sources/...` | N/A (product code) | JSON-encodable structs |
| Tests | `swiftanvil-anvil-runner/Tests/...` | N/A (product code) | Swift Testing |
| Plan review | `Children/4.4/REVIEW-PLAN.md` | `planning.child-4-4-review-plan` | This review |
| Result | `Children/4.4/RESULT.md` | `planning.child-4-4-result` | Post-execution |
| Review provenance | `Children/4.4/REVIEW-PROVENANCE.md` | `planning.child-4-4-provenance` | Post-execution |
| Worker capability output | `swiftanvil-meta/WORKER_CAPABILITIES.json` | `report.worker-capabilities` | Fills ORG_REPORT reserved section |

## Integration with Org Report

Child 4.3 reserved the "Worker Capabilities" section in `report.org-health` (`ORG_REPORT.md:94–100`). Child 4.4 fills it by:

1. Emitting `WORKER_CAPABILITIES.json` to `swiftanvil-meta/` after running on a host
2. The org-report generator (`script.org-report`) reads this file and includes it in `ORG_REPORT.md` / `ORG_REPORT.yml`

This decouples discovery from report generation: 4.4 produces data, 4.3's generator consumes it.

## Task Breakdown

| # | Task | Estimate | Dependencies |
|---|------|----------|--------------|
| 1 | Define capability types (Swift structs, Codable) | 45 min | None |
| 2 | Implement `discover` command | 1.5 hours | Task 1 |
| 3 | Implement `doctor` command | 1.5 hours | Task 1 |
| 4 | Implement tool detection (Swift, Xcode, git, gh) | 1 hour | Task 2 |
| 5 | Implement agent detection (claude, codex, gemini) | 45 min | Task 2 |
| 6 | Implement network detection (SSH, Tailscale) | 45 min | Task 2 |
| 7 | Implement power detection | 30 min | Task 2 |
| 8 | Write tests (Swift Testing) with fixtures | 1.5 hours | Tasks 2–7 |
| 9 | Generate `WORKER_CAPABILITIES.json` sample | 15 min | Task 8 |
| 10 | Update `ORG_REPORT.md` generator to read worker data | 30 min | Task 9 |
| 11 | Register artifacts in `REGISTRY.yml` | 15 min | Task 10 |
| 12 | Run enforcement validation | 15 min | Task 11 |
| 13 | Write `RESULT.md` and `REVIEW-PROVENANCE.md` | 30 min | Task 12 |
| 14 | Update `ROADMAP.md` | 15 min | Task 13 |
| 15 | Commit and push | 15 min | Task 14 |

**Total estimate: ~9 hours**

## Success Criteria (Verifiable Checklist)

- [ ] `anvil-runner discover --json` runs without errors and outputs valid JSON
- [ ] `anvil-runner doctor --json` runs without errors and outputs valid JSON
- [ ] JSON output matches the draft schema (schema_version, host, capabilities, agents, network, power, checks)
- [ ] Doctor exit code is 0 when all checks pass, 1 when any check fails
- [ ] Doctor exit code is 0 when only warnings present
- [ ] Swift detection works (`swift --version` parsing)
- [ ] Xcode detection works (`xcodebuild -version` parsing, macOS only)
- [ ] Git detection works
- [ ] GitHub CLI detection works (`gh --version` + `gh auth status`)
- [ ] Agent CLI detection works for claude, codex, gemini (all optional — warn, not fail, if missing)
- [ ] SSH detection works (check `ssh` binary + `~/.ssh/` key presence)
- [ ] Tailscale detection works (check `tailscale` binary + `tailscale status`)
- [ ] Power detection works (macOS: `pmset`; Linux: `systemctl` or `/sys`)
- [ ] No network calls are made during detection
- [ ] No secrets appear in JSON output
- [ ] `WORKER_CAPABILITIES.json` is generated and valid
- [ ] `ORG_REPORT.md` generator includes worker capabilities section
- [ ] All tests pass (`swift test` in `swiftanvil-anvil-runner`)
- [ ] `swiftanvil-enforcement` registry validation passes
- [ ] `swiftanvil-enforcement` review provenance validation passes
- [ ] `planning.child-4-4-result` and `planning.child-4-4-provenance` registered

## Risks

| Risk | Mitigation |
|------|-----------|
| False negatives from PATH-only detection | Document detection method; warn rather than fail for ambiguous cases |
| Secret exposure in JSON output | Explicitly exclude env vars, key files, and tokens from all output |
| Doctor snapshot becomes stale | Include `generated_at` timestamp; document that doctor is a point-in-time check |
| Platform drift (macOS vs Linux) | Gate macOS-specific checks (`#if os(macOS)`); Linux checks as fallback |
| Tool version parsing fragility | Use regex with fallbacks; test with multiple known versions |

## Dependencies

- Child 4.3 is complete. The "Worker Capabilities" section in `report.org-health` is reserved and waiting for 4.4's output.
- 4.4 produces `WORKER_CAPABILITIES.json` which the org-report generator consumes.

## Review Request Intention

The plan review should check whether the capability schema is sufficient for provisioning decisions (Child 4.5) and whether the discovery/doctor commands are truly read-only and safe.
