# Child 4.4 Plan Review

## Verdict

NEEDS_REVISION

## Summary

The plan correctly identifies the right child boundary — a read-only capability and doctor pass before any
provisioning — and the non-goals are crisp. However, the plan is materially under-specified relative to the
4.3 baseline that an independent agent has to execute against. It lacks a task breakdown, a deliverables/registry-IDs
table, a verifiable success-criteria checklist, the explicit command names, a capability schema sketch, and the
relationship to `report.org-health`'s reserved "Worker Capabilities" section. The Dependencies section is also
written as if Child 4.3 is still upcoming, but 4.3 is already complete (`ROADMAP.md:326–346`) and has already
reserved space for 4.4's output (`ORG_REPORT.md:94–100`). These gaps make the plan agent-executable only with
significant additional guesswork, which conflicts with the agent-agnostic principle in `workflow.orchestration`.

## Strengths

- Scope is appropriately narrow: read-only discovery + doctor, no install/configure (`PLAN.md:13–18`, `21–25`).
- Non-goals explicitly forbid the most likely scope-creep traps: provisioning Tailscale/SSH/Xcode/agents/power
  (`PLAN.md:22`), assuming fixed install paths (`PLAN.md:23`), requiring paid LLM access (`PLAN.md:24`), and leaking
  secrets in report output (`PLAN.md:25`).
- Output split between JSON for automation and human-readable text is the right call (`PLAN.md:18`) — this is what
  `ORG_REPORT.yml` / `ORG_REPORT.md` will need to consume.
- Targets the correct primary repo (`swiftanvil-anvil-runner`) consistent with `Children/README.md:53` and
  `ROADMAP.md:349`.
- Routes auth-readiness failures to `agents.diagnostics`, which is an existing registered doc
  (`REGISTRY.yml:46`).

## Concerns

### Critical

- **Success criteria are not verifiable (`PLAN.md:37–42`).** Compare with `Children/4.3/PLAN.md:114–127`, which uses a
  concrete checkbox checklist (artifact exists, parses as YAML, names next child by registry ID, validation script
  passes). The 4.4 criteria as written ("A contributor can run the command locally without changing the machine",
  "The output can tell whether the host is suitable for…") cannot be objectively confirmed by an independent
  reviewer. The orchestration framework explicitly requires that Step 1 produce verifiable success criteria
  (`ORCHESTRATION_FRAMEWORK.md:97`).
- **No Deliverables / Registry IDs table.** 4.3 listed every artifact with its path and registry ID
  (`Children/4.3/PLAN.md:88–99`). 4.4 lists deliverable categories (`PLAN.md:29–36`) but never names files, paths,
  command names, or the registry IDs that must be added to `REGISTRY.yml`. The plan does not register
  `planning.child-4-4-result` or `planning.child-4-4-provenance`, which the registry-enforcement check will require
  at merge time.
- **Dependencies section is stale (`PLAN.md:46`).** It says "Child 4.3 should define how org health reports consume
  worker capability output." 4.3 is already complete and already defined this: `ORG_REPORT.md:94–100` reserves a
  "Worker Capabilities" section enumerating exactly the fields 4.4 is expected to provide (host capabilities,
  installed tools, agent availability + auth readiness, SSH posture, Tailscale availability, power-management
  posture). The plan needs to flip this around: the contract already exists; 4.4's job is to produce output that
  fills the reserved section.

### Major

- **No command names specified.** The plan says "discovery command" and "doctor command" (`PLAN.md:14–15`) but does
  not state the invocations (e.g., `anvil-runner discover`, `anvil-runner doctor`, or subcommands of an existing
  AnvilRunner verb). The reviewer cannot verify command surface, and the executing agent will have to invent the
  CLI shape.
- **No capability schema sketch.** "Capability schema" is listed as a deliverable (`PLAN.md:31`) but no fields,
  enum values (e.g., what `pass`/`warn`/`fail` means), or JSON skeleton appear. 4.3 included a draft YAML schema
  (`Children/4.3/PLAN.md:51–86`); 4.4 should do the same for its JSON output so that `report.org-health-data`'s
  worker-capabilities consumer has a contract to read against.
- **No task breakdown with estimates.** 4.3 listed 7 tasks with hour estimates and dependencies
  (`Children/4.3/PLAN.md:100–112`). 4.4 has none, so total effort and ordering are opaque.
- **No agent-CLI inventory.** "Common agent CLIs" (`PLAN.md:16`) is vague. The plan should enumerate which CLIs
  are in scope for v1 detection (e.g., `claude`, `codex`, `kimi`, `gemini`) and what "auth readiness where safe"
  means per CLI — what probe is safe, what is not.
- **No risks section.** 4.3 included one (`Children/4.3/PLAN.md:140–148`); 4.4's omits it. Likely risks worth
  surfacing: false negatives from PATH-only detection, accidental secret exposure in JSON, the doctor command
  being read as authoritative when the host changes underneath it, and platform drift (macOS vs Linux runners).

### Minor

- Status line reads "Planned." (`PLAN.md:5`) — `ROADMAP.md:354` and `Children/README.md:53` say "Planned" without
  the period; trivial but worth aligning since registry/enforcement may match status strings.
- "Authentication failures point to `agents.diagnostics`" (`PLAN.md:42`) — clarify whether this means the doctor
  output literally prints `agents.diagnostics` as a registry ID pointer, or links to the file path. Both are
  defensible; pick one.
- The plan does not mention the file location for the plan, result, and provenance artifacts under
  `Children/4.4/`. Other children include this implicitly via the registry IDs; here it is absent entirely.
- "Tests | swiftanvil-anvil-runner | Fixtures for multiple host states" (`PLAN.md:35`) does not specify whether
  these are Swift Testing tests (the org standard per `ROADMAP.md:419`) or unit tests via XCTest. Should be Swift
  Testing.

## Questions for Builder

1. What are the exact CLI invocations? Suggested: `anvil-runner discover [--json]` and
   `anvil-runner doctor [--json]`. Confirm or override.
2. What agent CLIs are in v1 scope? Suggested: `claude`, `codex`, `gemini`, `kimi`. Anything else (Cursor,
   Continue, Aider)?
3. What does "safe auth probe" mean concretely per CLI? `claude --version`? Touching a known config path?
   No network calls?
4. How is the capability output surfaced into `ORG_REPORT.md` / `ORG_REPORT.yml`'s reserved "Worker
   Capabilities" section — does 4.4 emit a file the org-report generator reads, or does 4.4 expose a JSON
   command the generator shells out to? The former is preferable for offline runs.
5. Will the JSON schema be versioned (e.g., `schema_version: 1`) so 4.5 can rely on stable field names?
6. Does doctor exit non-zero on `fail` checks, or always 0 with status in JSON? CI integration depends on this.
7. Are these tests Swift Testing per the org standard? Where do the host-state fixtures live?

## Suggested Improvements

| # | Improvement | Priority | Effort |
|---|------------|----------|--------|
| 1 | Replace "Success Criteria" with a verifiable checkbox checklist matching 4.3's style (commands exist, JSON parses, doctor exits N on fail, agent-CLI detection covers the v1 list, registry IDs registered, enforcement passes). | P1 | Small |
| 2 | Add a Deliverables & Registry IDs table naming every file path (`Children/4.4/PLAN.md`, `RESULT.md`, `REVIEW-PROVENANCE.md`, the runner source files, the schema doc) with registry IDs `planning.child-4-4`, `planning.child-4-4-result`, `planning.child-4-4-provenance`, and any new `capability.schema` ID. | P1 | Small |
| 3 | Rewrite the Dependencies section: 4.3 is complete; 4.4 must produce output that fills the reserved "Worker Capabilities" section in `report.org-health` (`ORG_REPORT.md:94–100`). Spell out the integration point. | P1 | Small |
| 4 | Add a draft JSON capability schema (top-level fields, `checks[]` with `id`/`status`/`severity`/`hint`, host info block, agents block) — even a stub gives the executor and reviewer something concrete to align on. | P1 | Medium |
| 5 | State the exact CLI invocations (`anvil-runner discover`, `anvil-runner doctor`, flags). | P1 | Small |
| 6 | Enumerate the v1 agent-CLI detection list and define "safe auth probe" per CLI. | P2 | Small |
| 7 | Add a Task Breakdown table with estimates and dependencies, matching 4.3's format. | P2 | Small |
| 8 | Add a Risks table covering false negatives, secret exposure in JSON, doctor-snapshot staleness, platform drift. | P2 | Small |
| 9 | Specify Swift Testing as the test framework and where host-state fixtures live in the repo. | P3 | Small |
| 10 | Clarify whether doctor's exit code reflects fail-state or always 0. | P3 | Small |
