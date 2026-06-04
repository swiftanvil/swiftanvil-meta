# Child 4.4 Plan: Managed Worker Capability Discovery and Doctor

## Status

Planned.

## Goal

Teach AnvilRunner how to describe what a host can do and how healthy it is, without making privileged changes.

## Scope

- Define a capability model for a worker host.
- Add a read-only discovery command.
- Add a doctor command that reports missing or degraded capabilities.
- Detect installed developer tools, Swift/Xcode versions, common agent CLIs, authentication readiness where safe,
  SSH reachability state, Tailscale availability, and power-management posture.
- Support JSON output for automation and readable output for humans.

## Non-Goals

- Do not install or configure Tailscale, SSH, Xcode, agents, or power settings in this child.
- Do not assume tools live in one fixed path.
- Do not require paid access to any optional LLM provider.
- Do not expose secrets in report output.

## Proposed Deliverables

| Deliverable | Repo | Notes |
|-------------|------|-------|
| Capability schema | swiftanvil-anvil-runner | JSON-compatible contract |
| Discovery command | swiftanvil-anvil-runner | Read-only host scan |
| Doctor command | swiftanvil-anvil-runner | Actionable pass/warn/fail checks |
| Agent availability detection | swiftanvil-anvil-runner | Uses installed commands and safe auth probes |
| Tests | swiftanvil-anvil-runner | Fixtures for multiple host states |

## Success Criteria

- A contributor can run the command locally without changing the machine.
- The output can tell whether the host is suitable for Xcode builds, Swift tests, performance tests, or agent review.
- Missing optional tools are warnings, not hard failures.
- Authentication failures point to `agents.diagnostics`.

## Dependencies

- Child 4.3 should define how org health reports consume worker capability output.
