#!/bin/bash
# calculate-pms.sh — Calculate Package Maturity Score for all SwiftAnvil repos
# Usage: ./scripts/calculate-pms.sh [repo-path]
# If no repo-path given, scores all repos in the sibling directory
#
# HEURISTICS VERSION: 1.0 (initial approximations)
# These heuristics are pragmatic first-pass metrics. They intentionally trade
# precision for automation — e.g. "DocC catalog exists" instead of measuring
# coverage %, "git tag exists" instead of semver audit. Future versions should:
#   - Parse swift build output for warnings (not just pass/fail)
#   - Use swift-testing coverage when available
#   - Audit README completeness, not just existence
#   - Check semver compliance of tags, not just presence
#   - Integrate GitHub API for SPI listing, issue/PR counts
#   - Add dependabot/dependency audit for security
#
# See IMPROVEMENT_FRAMEWORK.md for the full PMS specification.

set -euo pipefail

WORKSPACE="${WORKSPACE:-$(cd "$(dirname "$0")/../.." && pwd)}"
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

score_repo() {
  local repo_dir="$1"
  local repo_name
  repo_name=$(basename "$repo_dir")

  if [[ ! -f "$repo_dir/Package.swift" ]]; then
    echo "{\"error\":\"Not a Swift package\"}" >&2
    return
  fi

  cd "$repo_dir"

  # Correctness (25 pts): swift build + swift test
  local correctness=0
  if swift build 2>/dev/null >/dev/null; then
    correctness=15
    if swift test 2>/dev/null >/dev/null; then
      correctness=25
    fi
  fi

  # Coverage (20 pts): test count
  local test_count=0
  if [[ -d Tests ]]; then
    test_count=$(find Tests -name "*.swift" -exec grep -l "@Test\|func test" {} \; 2>/dev/null | wc -l | tr -d ' ')
  fi
  local coverage=0
  if (( test_count >= 5 )); then coverage=20
  elif (( test_count >= 1 )); then coverage=15
  elif [[ -d Tests ]]; then coverage=5
  fi

  # Documentation (15 pts): README + DocC
  local documentation=0
  [[ -f README.md ]] && documentation=$((documentation + 8))
  [[ -d Sources ]] && [[ $(find Sources -name "*.docc" -type d 2>/dev/null | wc -l) -gt 0 ]] && documentation=$((documentation + 7))

  # API Stability (15 pts): git tag exists
  local api_stability=0
  if git tag -l 2>/dev/null | grep -q .; then
    api_stability=15
  fi

  # Performance (10 pts): BenchmarkKit in deps
  local performance=0
  if grep -q "swiftanvil-anvil-bench\|BenchmarkKit" Package.swift 2>/dev/null; then
    performance=10
  fi

  # Ecosystem (10 pts): CI workflow + remote
  local ecosystem=0
  [[ -f .github/workflows/ci.yml ]] && ecosystem=$((ecosystem + 5))
  git remote get-url origin 2>/dev/null >/dev/null && ecosystem=$((ecosystem + 5))

  # Security (5 pts): no hardcoded secrets
  local security=5
  if [[ -d Sources ]] && grep -riq "password\|secret\|token" Sources/ 2>/dev/null; then
    # Only flag if it looks like a real secret (not just variable names)
    if grep -riqE '"[a-zA-Z0-9]{16,}"' Sources/ 2>/dev/null; then
      security=0
    fi
  fi

  local total=$((correctness + coverage + documentation + api_stability + performance + ecosystem + security))

  local grade
  if (( total >= 90 )); then grade="A+"
  elif (( total >= 80 )); then grade="A"
  elif (( total >= 70 )); then grade="B"
  elif (( total >= 60 )); then grade="C"
  else grade="F"
  fi

  local now
  now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local next_review
  next_review=$(date -u -v+14d +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u -d "+14 days" +"%Y-%m-%dT%H:%M:%SZ")

  # Generate improvement_items based on low scores
  local improvement_items=""
  local items=()
  (( correctness < 25 )) && items+=("{\"id\":\"corr-1\",\"category\":\"correctness\",\"description\":\"Fix build or test failures\",\"impact\":$((25 - correctness)),\"effort\":\"small\"}")
  (( coverage < 20 )) && items+=("{\"id\":\"cov-1\",\"category\":\"coverage\",\"description\":\"Add more tests (target: 5+ test files)\",\"impact\":$((20 - coverage)),\"effort\":\"small\"}")
  (( documentation < 15 )) && items+=("{\"id\":\"doc-1\",\"category\":\"documentation\",\"description\":\"Add README or DocC catalog\",\"impact\":$((15 - documentation)),\"effort\":\"small\"}")
  (( api_stability < 15 )) && items+=("{\"id\":\"api-1\",\"category\":\"api_stability\",\"description\":\"Tag a semantic version release\",\"impact\":$((15 - api_stability)),\"effort\":\"small\"}")
  (( performance < 10 )) && items+=("{\"id\":\"perf-1\",\"category\":\"performance\",\"description\":\"Add BenchmarkKit performance tests\",\"impact\":$((10 - performance)),\"effort\":\"medium\"}")
  (( ecosystem < 10 )) && items+=("{\"id\":\"eco-1\",\"category\":\"ecosystem\",\"description\":\"Add CI workflow or push to GitHub remote\",\"impact\":$((10 - ecosystem)),\"effort\":\"small\"}")
  (( security < 5 )) && items+=("{\"id\":\"sec-1\",\"category\":\"security\",\"description\":\"Audit source for hardcoded secrets\",\"impact\":$((5 - security)),\"effort\":\"small\"}")

  if [[ ${#items[@]} -gt 0 ]]; then
    improvement_items=$(IFS=,; echo "[${items[*]}]")
  else
    improvement_items="[]"
  fi

  local json
  json=$(cat <<EOF
{
  "version": "1.0.0",
  "score": $total,
  "grade": "$grade",
  "breakdown": {
    "correctness": $correctness,
    "coverage": $coverage,
    "documentation": $documentation,
    "api_stability": $api_stability,
    "performance": $performance,
    "ecosystem": $ecosystem,
    "security": $security
  },
  "last_calculated": "$now",
  "next_review": "$next_review",
  "test_count": $test_count,
  "improvement_items": $improvement_items
}
EOF
)

  echo "$json" > package.improvement-score
  echo "$json"
}

# Main
main() {
  if [[ $# -eq 1 ]]; then
    score_repo "$1"
  else
    echo "["
    local first=true
    for repo in "${REPOS[@]}"; do
      local repo_path="$WORKSPACE/$repo"
      if [[ -d "$repo_path" ]]; then
        if $first; then first=false; else echo ","; fi
        score_repo "$repo_path" | jq -c '. + {"repo": "'"$repo"'"}' 2>/dev/null || true
      fi
    done
    echo "]"
  fi
}

main "$@"
