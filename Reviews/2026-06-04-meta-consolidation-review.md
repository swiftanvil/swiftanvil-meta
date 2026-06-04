# Review: SwiftAnvil Meta Repository Consolidation

**Reviewer**: Claude CLI (Opus 4.7, 1M context)
**Builder**: Kimi CLI (k1.6)
**Date**: 2026-06-04
**Request**: `Reviews/2026-06-04-meta-consolidation-review-request.md`

## Verdict

**NEEDS_REVISION** — the consolidation is mostly sound and the structural choices are defensible, but the registry contains at least one broken document ID (a registered path that does not exist on disk) and one unregistered file that does exist. Both must be reconciled before the registry can be trusted as a "canonical routing table." The remaining findings are P2/P3 polish.

## Summary

The consolidation accomplishes its core goal: phase children 1.1–3.3 are now physically present in `swiftanvil-meta/Children/`, the registry has stable IDs for them, the children index is restructured by phase, and `RESUME.md` adds a useful human-facing entry point. The naming conventions (`planning.child-N-M`, `planning.child-N-M-{result,review,review-plan,review-impl,provenance}`) are intuitive and scale. However, the registry was clearly transcribed from intent rather than verified against the filesystem: Child 2.1 ships with four distinct review-plan files on disk (CROSSHOST, CROSSHOST-v2, SELF, SELF-v2) but the registry points `planning.child-2-1-review-plan` at a `REVIEW-PLAN.md` that does not exist; Child 3.2 ships a `STATUS.md` that no registry entry references; Child 1.1 has no review variant at all (acceptable, but undocumented). The cold-start workflow is also heavier than necessary and `RESUME.md` is orphaned from the agent ladder. These are correctable in a single follow-up pass.

## Findings

### P1 (Blockers)

- [ ] **Registry references a non-existent file: `Children/2.1/REVIEW-PLAN.md`**
  Why it matters: `REGISTRY.yml:233-237` defines `planning.child-2-1-review-plan` with `path: Children/2.1/REVIEW-PLAN.md`, but the directory actually contains `REVIEW-PLAN-CROSSHOST.md`, `REVIEW-PLAN-CROSSHOST-v2.md`, `REVIEW-PLAN-SELF.md`, and `REVIEW-PLAN-SELF-v2.md`. Any agent resolving this ID gets a 404. The registry's whole purpose ("Only this registry owns document paths") is undermined if entries don't resolve.
  Fix: Either (a) rename one of the v2 files to canonical `REVIEW-PLAN.md` and archive the rest under `Children/2.1/archive/`, or (b) split into four registry entries: `planning.child-2-1-review-plan-crosshost`, `…-crosshost-v2`, `…-self`, `…-self-v2`, and remove the bare `-review-plan` entry. Option (a) is simpler and matches how other phase-2 children are structured.

- [ ] **Unregistered file: `Children/3.2/STATUS.md`**
  Why it matters: The file exists on disk but has no registry entry, so no document ID resolves to it. The review request explicitly asks why 3.2 lacks `RESULT.md` — the answer is that `STATUS.md` appears to be its result equivalent, but neither the filename nor the registry makes that legible.
  Fix: Either rename `STATUS.md` → `RESULT.md` (preferred — restores convention; add `aliases: [Children/3.2/STATUS.md]` to a new `planning.child-3-2-result` entry during the rename window) or register it as `planning.child-3-2-status` with a one-line comment in the registry explaining the historical divergence.

### P2 (Should Fix)

- [ ] **`RESUME.md` is orphaned from both startup ladders**
  Why it matters: `AGENTS.md:9-16` lists the agent startup sequence and never mentions `meta.resume`. `MEMORY/99-SESSION_START.md:14-24` also doesn't reference it. Only `RESUME.md` itself tells the reader where to go next (line 24). A human dropping into the repo cold has no signal from the README or AGENTS.md that `RESUME.md` is the "start here for humans" file.
  Fix: Add a one-line pointer at the top of `README.md` ("Humans resuming a session: see `meta.resume`. Agents: see `meta.agents`.") and add `meta.resume` to `99-SESSION_START.md` Step 1 under an explicit "Human-in-the-loop sessions only" subhead so agents skip it.

- [ ] **Session start is heavier than it needs to be (10 docs in Step 1)**
  Why it matters: `99-SESSION_START.md` Step 1 lists 10 doc IDs to read in order; AGENTS.md adds 5 more above that. For a cold-start agent, that's ~15 docs before any work begins. The review request itself flags this. Several of those (`memory.meta`, `memory.identity`, `improvement.framework`) rarely change session-to-session and don't gate decision-making.
  Fix: Split Step 1 into "Always read" (registry, identity, orchestration, packages, children-index, naming) and "Read when relevant" (improvement framework only if PMS<80; agent compatibility/diagnostics only on failure; platform policy only when touching platform-version code). Move the conditionals into Step 2 (Check Health). Aim for ≤6 mandatory reads.

- [ ] **Review-artifact naming convention is inconsistent across phases and undocumented**
  Why it matters: Phase 1 children use a single `REVIEW.md`. Phase 2/3 use `REVIEW-PLAN.md` + `REVIEW-IMPL.md`. Phase 3.4/3.5 and Phase 4 use `REVIEW-PROVENANCE.md` instead. This is historical reality, but `Children/README.md` doesn't explain it, so a future agent reading the index will assume the registry is incomplete (e.g., "why no `planning.child-1-2-review-plan`?").
  Fix: Add a "Document conventions per phase" subsection to `Children/README.md` documenting the three eras (single REVIEW → PLAN/IMPL split → PROVENANCE-only with cross-host enforcement). One paragraph is enough.

- [ ] **`history.phase-1-plan` is registered but `PHASE_2_PLAN.md` / `PHASE_3_PLAN.md` are absent from `HISTORY/`**
  Why it matters: `HISTORY/` currently holds one file. The registry promise is "preserve original phase plans as historical reference." Either Phases 2/3 had no consolidated plan doc (in which case say so), or the consolidation is incomplete.
  Fix: Either backfill the missing phase plans from the iFoundation archive, or add a `HISTORY/README.md` clarifying that Phase 1 was the only phase with a standalone plan doc (the rest were planned per-child).

### P3 (Nice to Have)

- [ ] **44 hand-curated registry entries are mostly boilerplate**
  Why it matters: Almost every `planning.child-N-M-*` entry has identical structure (title, path, audience: [human, agent], aliases: []). The maintenance burden scales linearly with children, and the review request flags this. There's no validation against the filesystem (which is how the 2.1 break above slipped in).
  Fix: Add a one-shot script `scripts/sync-registry.sh` that walks `Children/*/` and emits / verifies expected entries from filename conventions. Run it in CI as a lint step. Don't generate the registry from scratch (you'd lose `audience`/`aliases`), just verify every `path:` resolves and every `Children/*/*.md` is referenced.

- [ ] **`aliases: []` is noise on most entries**
  Why it matters: ~50 entries have `aliases: []`. It conveys no information.
  Fix: Make `aliases` optional in the schema; omit when empty. Mention in the registry header that absent `aliases` means none.

- [ ] **`RESUME.md` "Last Session" date will drift**
  Why it matters: Manually maintained dates rot. `RESUME.md:11` already encodes 2026-06-04 in markdown.
  Fix: Either drop the date (rely on `git log -1 RESUME.md`) or add a pre-commit hook that updates it. Low-priority; mention the convention in a comment.

- [ ] **`Children/README.md:31` is vague**
  Why it matters: "The historical roadmap overstated Phase 3 completion" doesn't link to the corrective work. A future agent has no trail to follow.
  Fix: Append "(see commit `6a38c74` and `planning.child-3-4`)" or similar.

- [ ] **`meta.resume` and `meta.session-start` differ only by audience**
  Why it matters: The IDs don't telegraph that one is human-only and one is agent-only. A skimming reader could pick the wrong one.
  Fix: Optional rename to `meta.resume-human` / `meta.session-start-agent`, or add a one-line comment block above each entry. Low value; the `audience:` field is already authoritative.

- [ ] **Cross-repo duplication is acknowledged but not scheduled**
  Why it matters: The review request asks about `swiftanvil-cli/Children/` and `swiftanvil-anvil-project/Children/` duplicates. They are stale once meta is canonical. Leaving them invites the next agent to update the wrong copy.
  Fix: Open a follow-up child (e.g., 4.6 — Cross-repo planning-doc cleanup) that replaces the duplicate `Children/` dirs in sibling repos with a one-line `Children/README.md` pointing to `swiftanvil-meta`. Do not block this review on it.

## Recommendations

| # | Recommendation | Priority | Effort |
|---|---------------|----------|--------|
| 1 | Reconcile `planning.child-2-1-review-plan` with the four actual review-plan files in `Children/2.1/` | P1 | Small |
| 2 | Register or rename `Children/3.2/STATUS.md` to restore RESULT convention | P1 | Small |
| 3 | Add `meta.resume` to `99-SESSION_START.md` (human path) and `README.md` top | P2 | Small |
| 4 | Split session-start Step 1 into mandatory vs. conditional reads (target ≤6 mandatory) | P2 | Small |
| 5 | Document the three review-artifact conventions in `Children/README.md` | P2 | Small |
| 6 | Either backfill `HISTORY/PHASE_{2,3}_PLAN.md` or add `HISTORY/README.md` clarifying scope | P2 | Small |
| 7 | Add `scripts/sync-registry.sh` to verify registry paths resolve and no `Children/*/*.md` is unregistered; wire into CI | P3 | Medium |
| 8 | Drop empty `aliases: []` from registry entries; document the convention in the header | P3 | Small |
| 9 | Append commit/child references to vague historical notes in `Children/README.md` | P3 | Small |
| 10 | Schedule a follow-up child to deduplicate `Children/` in `swiftanvil-cli/` and `swiftanvil-anvil-project/` | P3 | Medium |

## Questions for the Builder

1. **Was the 2.1 review-plan filename collision intentional?** Were CROSSHOST and SELF kept side-by-side deliberately (e.g., to preserve both reviewers' artifacts), or was a canonical merge planned but not completed? The answer drives whether to consolidate or to expand the registry to four entries.
2. **What is `Children/3.2/STATUS.md`?** Is it the result document under a different name, or is it a status snapshot that supplements an absent RESULT? The review request asks whether the missing RESULT should be investigated — please confirm.
3. **For historical children that predate `REVIEW-PROVENANCE.md`, is a "backfilled" note in the body sufficient, or do you want explicit machine-readable provenance metadata (e.g., `backfilled: true`, `original_repo: iFoundation`, `original_sha: <hash>`) in the file frontmatter?** This affects whether 1.x/2.x review files need a small schema update.
4. **Should `RESUME.md` continue to be human-only, or would a unified "session-start" doc with explicit "Human path" / "Agent path" sections be cleaner?** Both work; the current split is defensible but creates the orphan-pointer problem flagged in P2.
5. **For the registry-sync automation question:** would you prefer a verifier (CI fails if registry and filesystem disagree) or a generator (registry rebuilt from filesystem on each commit)? The verifier preserves human-curated fields like `audience` and `aliases`; the generator is more aggressive but riskier. I recommend the verifier — but flagging the choice.
6. **Cross-repo duplicate `Children/` directories — is there any current consumer of them that would break if they were replaced with pointers?** If no, the cleanup is mechanical; if yes (e.g., a CI script in another repo greps its own `Children/`), the scope expands.

---

*Review written: 2026-06-04 by Claude CLI (Opus 4.7, 1M context). Cross-host: different model from builder (Kimi k1.6). Saved to `Reviews/2026-06-04-meta-consolidation-review.md`.*
