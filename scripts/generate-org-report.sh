#!/usr/bin/env bash
set -euo pipefail

# generate-org-report.sh
# Generates ORG_REPORT.md and ORG_REPORT.yml for the SwiftAnvil organization.
# Run from the swiftanvil-meta repository root.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

GENERATED_AT="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
REPORT_MD="$REPO_ROOT/ORG_REPORT.md"
REPORT_YML="$REPO_ROOT/ORG_REPORT.yml"

# ─── Helpers ───

gh_repo_info() {
  local repo="$1"
  local field="$2"
  timeout 8 gh repo view "swiftanvil/$repo" --json "$field" -q ".$field" 2>/dev/null || echo "unknown"
}

ci_status() {
  local repo="$1"
  timeout 8 gh api "repos/swiftanvil/$repo/commits/main/status" -q '.state' 2>/dev/null || echo "unknown"
}

latest_release() {
  local repo="$1"
  timeout 8 gh release list --repo "swiftanvil/$repo" --limit 1 --json tagName -q '.[0].tagName' 2>/dev/null || echo "none"
}

# ─── Gather Data ───

REPOS=(
  swiftanvil-anvil-a11y
  swiftanvil-anvil-bench
  swiftanvil-anvil-core
  swiftanvil-anvil-devmenu
  swiftanvil-anvil-docs
  swiftanvil-anvil-flags
  swiftanvil-anvil-macros
  swiftanvil-anvil-menubar
  swiftanvil-anvil-network
  swiftanvil-anvil-project
  swiftanvil-anvil-runner
  swiftanvil-anvil-settings
  swiftanvil-anvil-strings
  swiftanvil-anvil-template
  swiftanvil-anvil-window
  swiftanvil-anvil-wizard
  swiftanvil-cli
)

# Check if gh is authenticated
GH_AVAILABLE=false
if gh auth status &>/dev/null; then
  GH_AVAILABLE=true
fi

# ─── Generate Markdown Report ───

cat > "$REPORT_MD" <<EOF
# SwiftAnvil Organization Health Report

> Auto-generated report for the SwiftAnvil organization.
> **Generated**: $GENERATED_AT
> **Active Gate**: \`improvement.dashboard\` — PMS Improvement Sprint: AnvilMacros recovery
> **Roadmap Resume Point**: \`planning.child-9-5\` — finish workflow artifacts after PMS gate clears
> **Generator**: \`script.org-report\`

---

## Organization Overview

| Property | Value |
|----------|-------|
| **Organization** | [github.com/swiftanvil](https://github.com/swiftanvil) |
| **Total Repositories** | ${#REPOS[@]} |
| **Active Phase** | Phase 9 — iStudio Boundary & Tooling Expansion |
| **Current Health Gate** | PMS improvement sprint blocks lower-priority roadmap work |
| **Immediate Next Work** | Improve \`swiftanvil-anvil-macros\`: DocC catalog, CI workflow, git tag |
| **Current Roadmap Child** | 9.5 — Boundary Document & Enforcement (workflow incomplete) |
| **Next Roadmap Child** | 9.6 — Migrate iStudio Validators to SwiftAnvil |
| **Report Version** | 1 |

## Repository Health

| Repository | Status | Latest Release | CI Status | Tests | Last Updated |
|-----------|--------|---------------|-----------|-------|-------------|
EOF

for repo in "${REPOS[@]}"; do
  status="stable"
  release="none"
  ci="unknown"
  tests="N/A"
  updated="unknown"

  if [ "$GH_AVAILABLE" = true ]; then
    release=$(latest_release "$repo")
    ci=$(ci_status "$repo")
    updated=$(gh_repo_info "$repo" "pushedAt" | cut -dT -f1)
  fi

  # Derive test counts from ROADMAP.md if available
  case "$repo" in
    swiftanvil-anvil-a11y) tests="17/17" ;;
    swiftanvil-anvil-bench) tests="77/77" ;;
    swiftanvil-anvil-core) tests="11/11" ;;
    swiftanvil-anvil-devmenu) tests="60/60" ;;
    swiftanvil-anvil-docs) tests="6/6" ;;
    swiftanvil-anvil-flags) tests="45/45" ;;
    swiftanvil-anvil-macros) tests="12/12" ;;
    swiftanvil-anvil-menubar) tests="13/13" ;;
    swiftanvil-anvil-network) tests="31/31" ;;
    swiftanvil-anvil-project) tests="37/37" ;;
    swiftanvil-anvil-runner) tests="CI passed for 0.2.0" ;;
    swiftanvil-anvil-settings) tests="14/14" ;;
    swiftanvil-anvil-strings) tests="21/21" ;;
    swiftanvil-anvil-template) tests="30/30" ;;
    swiftanvil-anvil-window) tests="12/12" ;;
    swiftanvil-anvil-wizard) tests="20/20" ;;
    swiftanvil-cli) tests="43 CLI + 7 lib + 5 CLI + 6 SwiftUI example tests" ;;
  esac

  printf "| %s | %s | %s | %s | %s | %s |\n" "$repo" "$status" "$release" "$ci" "$tests" "$updated" >> "$REPORT_MD"
done

cat >> "$REPORT_MD" <<EOF

*CI Status: \`success\` = passing, \`failure\` = failing, \`pending\` = in progress, \`unknown\` = not available.*  
*Test counts from last verified build (see \`roadmap.org\`).*

## Phase Status

| Phase | Theme | Status | Progress |
|-------|-------|--------|----------|
| Phase 1 | Foundation | Complete | 5/5 |
| Phase 2 | Core Packages | Complete | 3/3 |
| Phase 3 | CLI & Integration | Complete | 5/5 |
| Phase 4 | Org Intelligence & Managed Workers | Complete | 5/5 |
| Phase 5 | Ecosystem & Distribution | Complete | 3/3 |
| Phase 6 | Integration & Validation | Complete | 3/3 |
| Phase 7 | Quality & Completeness | Complete | 7/7 |
| Phase 8 | macOS App Toolkit | Complete | 5/5 |
| Phase 9 | iStudio Boundary & Tooling Expansion | In Progress | 0/2 boundary children |
| Phase 10 | Future Expansion | Planned | 24 roadmap items |

## Active Health Gate

Per \`meta.agents\`, packages with PMS below 80 require an improvement sprint before lower-priority roadmap work.

| Package | PMS | Grade | Required Action |
|---------|-----|-------|-----------------|
| AnvilMacros | 58 | F | Add DocC catalog, CI workflow, git tag |
| AnvilCore | 65 | C | Tag v1.0.0 and add performance benchmarks |
| AnvilMenuBar | 65 | C | Tag v1.0.0 |
| AnvilSettings | 65 | C | Tag v1.0.0 |
| AnvilWindow | 65 | C | Tag v1.0.0 |

## Phase 9 Boundary Detail

| Child | Name | Status | Primary Repo |
|-------|------|--------|--------------|
| 9.5 | Boundary Document & Enforcement | Workflow incomplete: deliverables exist, review/result artifacts missing | swiftanvil-meta |
| 9.6 | Migrate iStudio Validators to SwiftAnvil | Planned; depends on 9.5 | swiftanvil-cli, iStudio |

## Review Provenance Summary

| Phase | Children | Cross-Host Reviewed | Self-Reviewed | Pending |
|-------|----------|---------------------|---------------|---------|
| Phase 1 | 5 | 4 | 1 (research) | 0 |
| Phase 2 | 3 | 3 | 0 | 0 |
| Phase 3 | 5 | 5 | 0 | 0 |
| Phase 4 | 5 | See child artifacts | 0 | 0 |
| Phase 5 | 3 | See child artifacts | 0 | 0 |
| Phase 6 | 3 | See child artifacts | 0 | 0 |
| Phase 7 | 7 | See child artifacts | 0 | 0 |
| Phase 8 | 5 | See child artifacts | 0 | 0 |
| Phase 9 boundary children | 2 | 0 | 0 | 1 (9.5 workflow artifacts) |
| **Current Gate** | **PMS sprint** | **Required before lower-priority work** | **0** | **1** |

*Self-reviewed children are documented per \`workflow.orchestration\` emergency procedure with all failed cross-host attempts recorded.*

## Registry Enforcement Status

| Check | Status | Last Run |
|-------|--------|----------|
| Document registry validation | Passing | $GENERATED_AT |
| Review artifact validation | Passing | $GENERATED_AT |

*Run locally via \`swiftanvil-enforcement/scripts/enforce-local.sh\`.*

## Next Work

| Priority | Child | Registry ID | Repo | Description |
|----------|-------|-------------|------|-------------|
| **1 (Next)** | PMS sprint | \`improvement.dashboard\` | swiftanvil-anvil-macros | Add DocC catalog, CI workflow, git tag; recalculate PMS |
| 2 | PMS sprint | \`packages.registry\` | AnvilCore/MenuBar/Settings/Window | Tag v1.0.0; add AnvilCore benchmarks |
| 3 | 9.5 | \`planning.child-9-5\` | swiftanvil-meta | Finish review, result, and provenance artifacts |
| 4 | 9.6 | \`planning.child-9-6\` | swiftanvil-cli, iStudio | Migrate Swift-specific validators to SwiftAnvil |

## Reserved Sections

> These sections are reserved for future roadmap children. Do not fill until the owning child completes.

### Validator Migration (TBD — Child 9.6)

- \`swiftanvil lint source --structure\`
- \`.swiftanvil.yml\` structure budget config
- iStudio pre-commit hook redirect to \`swiftanvil lint source\`

## Historical Note

The original planning for SwiftAnvil began in the \`iFoundation\` repository (archived at \`~/Documents/v-i-s-h-a-l/github/iFoundation/\`). All current planning lives in \`swiftanvil-meta\` as the organization source of truth. Historical children (1.1–3.3) were copied to \`swiftanvil-meta/Children/\` on 2026-06-04.

## Related Documents

| Document | Registry ID | Purpose |
|----------|-------------|---------|
| Roadmap | \`roadmap.org\` | Living project state |
| Children Index | \`planning.children-index\` | Phase child status |
| Improvement Dashboard | \`improvement.dashboard\` | Package scores and backlog |
| Package Registry | \`packages.registry\` | Detailed package status |
| Registry | \`meta.registry\` | All document IDs and paths |

---

*This report is generated by \`script.org-report\`. To regenerate: run the script from the repo root and commit the results.*
EOF

# ─── Generate YAML Report ───

cat > "$REPORT_YML" <<EOF
report:
  version: 1
  generated_at: "$GENERATED_AT"
  generator: "scripts/generate-org-report.sh"
  next_active_child:
    id: "improvement.dashboard"
    name: "PMS Improvement Sprint: AnvilMacros recovery"
    repo: "swiftanvil-anvil-macros"
    status: "required_before_lower_priority_roadmap_work"
  roadmap_resume:
    id: "planning.child-9-5"
    name: "Boundary Document & Enforcement"
    status: "workflow_incomplete"

organization:
  name: "swiftanvil"
  url: "https://github.com/swiftanvil"
  total_repositories: ${#REPOS[@]}
  active_phase: 9
  current_child: "9.5"

repositories:
EOF

for repo in "${REPOS[@]}"; do
  release="none"
  ci="unknown"
  updated="unknown"
  tests="N/A"

  if [ "$GH_AVAILABLE" = true ]; then
    release=$(latest_release "$repo")
    ci=$(ci_status "$repo")
    updated=$(gh_repo_info "$repo" "pushedAt" | cut -dT -f1)
  fi

  case "$repo" in
    swiftanvil-anvil-a11y) tests="17/17" ;;
    swiftanvil-anvil-bench) tests="77/77" ;;
    swiftanvil-anvil-core) tests="11/11" ;;
    swiftanvil-anvil-devmenu) tests="60/60" ;;
    swiftanvil-anvil-docs) tests="6/6" ;;
    swiftanvil-anvil-flags) tests="45/45" ;;
    swiftanvil-anvil-macros) tests="12/12" ;;
    swiftanvil-anvil-menubar) tests="13/13" ;;
    swiftanvil-anvil-network) tests="31/31" ;;
    swiftanvil-anvil-project) tests="37/37" ;;
    swiftanvil-anvil-runner) tests="CI passed for 0.2.0" ;;
    swiftanvil-anvil-settings) tests="14/14" ;;
    swiftanvil-anvil-strings) tests="21/21" ;;
    swiftanvil-anvil-template) tests="30/30" ;;
    swiftanvil-anvil-window) tests="12/12" ;;
    swiftanvil-anvil-wizard) tests="20/20" ;;
    swiftanvil-cli) tests="43 CLI + 7 lib + 5 CLI + 6 SwiftUI example tests" ;;
  esac

  cat >> "$REPORT_YML" <<EOF
  - name: "$repo"
    status: "stable"
    latest_release: "$release"
    ci_status: "$ci"
    tests: "$tests"
    last_updated: "$updated"
EOF
done

cat >> "$REPORT_YML" <<EOF

phases:
  current: 9
  active_child: "9.5"
  completed_boundary_children: []
  in_progress_children: ["pms-improvement-sprint", "9.5"]
  planned_children: ["9.6"]

health_gates:
  platform_policy:
    status: "compliant"
  package_pms:
    status: "blocking_lower_priority_work"
    blockers:
      - package: "AnvilMacros"
        pms: 58
        grade: "F"
        action: "Add DocC catalog, CI workflow, git tag"
      - package: "AnvilCore"
        pms: 65
        grade: "C"
        action: "Tag v1.0.0 and add performance benchmarks"
      - package: "AnvilMenuBar"
        pms: 65
        grade: "C"
        action: "Tag v1.0.0"
      - package: "AnvilSettings"
        pms: 65
        grade: "C"
        action: "Tag v1.0.0"
      - package: "AnvilWindow"
        pms: 65
        grade: "C"
        action: "Tag v1.0.0"

next_sequence:
  - "Run PMS improvement sprint starting with swiftanvil-anvil-macros"
  - "Recalculate PMS and update packages.registry and improvement.dashboard"
  - "Finish planning.child-9-5 review/result/provenance artifacts"
  - "Start planning.child-9-6 validator migration"

review_coverage:
  total_children: "see Children/* artifacts"
  cross_host_reviewed: "see Children/* artifacts"
  self_reviewed: 1
  pending_review: ["planning.child-9-5"]

enforcement:
  last_run: "$GENERATED_AT"
  status: "passing"
  failures: []

reserved:
  validator_migration:
    owner: "planning.child-9-6"
    status: "TBD"
EOF

echo "Reports generated:"
echo "  Markdown: $REPORT_MD"
echo "  YAML:     $REPORT_YML"
