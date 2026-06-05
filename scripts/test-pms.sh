#!/bin/bash
# test-pms.sh — Fixture-based tests for calculate-pms.sh
# Usage: ./scripts/test-pms.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CALCULATE_SCRIPT="$SCRIPT_DIR/calculate-pms.sh"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

PASS=0
FAIL=0

assert_eq() {
  local expected="$1"
  local actual="$2"
  local label="$3"
  if [[ "$expected" == "$actual" ]]; then
    echo "  ✅ $label"
    ((PASS++))
  else
    echo "  ❌ $label: expected '$expected', got '$actual'"
    ((FAIL++))
  fi
}

# Test 1: Score range validation (0-100)
echo "Test 1: Score is within valid range (0-100)"
WORKSPACE="${WORKSPACE:-$(cd "$(dirname "$0")/../.." && pwd)}"
for repo in "$WORKSPACE"/swiftanvil-*; do
  if [[ -f "$repo/Package.swift" && -f "$repo/package.improvement-score" ]]; then
    score=$(jq '.score' "$repo/package.improvement-score")
    if (( score >= 0 && score <= 100 )); then
      : # ok
    else
      echo "  ❌ Score out of range for $(basename "$repo"): $score"
      ((FAIL++))
      continue
    fi
  fi
done
echo "  ✅ All scores in range 0-100"
((PASS++))

# Test 2: JSON schema validation
echo "Test 2: JSON output has required fields"
for repo in "$WORKSPACE"/swiftanvil-*; do
  if [[ -f "$repo/package.improvement-score" ]]; then
    if jq -e '.version and .score and .grade and .breakdown and .last_calculated and .next_review' "$repo/package.improvement-score" >/dev/null 2>&1; then
      : # ok
    else
      echo "  ❌ Missing required fields in $(basename "$repo")"
      ((FAIL++))
      continue
    fi
  fi
done
echo "  ✅ All JSON has required fields"
((PASS++))

# Test 3: Grade matches score thresholds
echo "Test 3: Grade matches score thresholds"
for repo in "$WORKSPACE"/swiftanvil-*; do
  if [[ -f "$repo/package.improvement-score" ]]; then
    score=$(jq '.score' "$repo/package.improvement-score")
    grade=$(jq -r '.grade' "$repo/package.improvement-score")
    expected_grade=""
    if (( score >= 90 )); then expected_grade="A+"
    elif (( score >= 80 )); then expected_grade="A"
    elif (( score >= 70 )); then expected_grade="B"
    elif (( score >= 60 )); then expected_grade="C"
    else expected_grade="F"
    fi
    if [[ "$grade" == "$expected_grade" ]]; then
      : # ok
    else
      echo "  ❌ Grade mismatch in $(basename "$repo"): score=$score, grade=$grade, expected=$expected_grade"
      ((FAIL++))
      continue
    fi
  fi
done
echo "  ✅ All grades match score thresholds"
((PASS++))

# Test 4: Breakdown sums to total score
echo "Test 4: Breakdown sums to total score"
for repo in "$WORKSPACE"/swiftanvil-*; do
  if [[ -f "$repo/package.improvement-score" ]]; then
    total=$(jq '.score' "$repo/package.improvement-score")
    sum=$(jq '.breakdown.correctness + .breakdown.coverage + .breakdown.documentation + .breakdown.api_stability + .breakdown.performance + .breakdown.ecosystem + .breakdown.security' "$repo/package.improvement-score")
    if (( total == sum )); then
      : # ok
    else
      echo "  ❌ Breakdown sum mismatch in $(basename "$repo"): total=$total, sum=$sum"
      ((FAIL++))
      continue
    fi
  fi
done
echo "  ✅ All breakdowns sum to total score"
((PASS++))

# Test 5: Script runs without errors on a single repo
echo "Test 5: Script runs without errors on single repo"
TEST_REPO="$TMPDIR/test-repo"
mkdir -p "$TEST_REPO/Sources/Test"
mkdir -p "$TEST_REPO/Tests"
cat > "$TEST_REPO/Package.swift" <<'EOF'
// swift-tools-version:6.0
import PackageDescription
let package = Package(
  name: "TestRepo",
  products: [.library(name: "TestRepo", targets: ["Test"])],
  targets: [.target(name: "Test"), .testTarget(name: "TestTests", dependencies: ["Test"])]
)
EOF
echo 'print("hello")' > "$TEST_REPO/Sources/Test/Test.swift"
echo 'import Testing; @Test func example() {}' > "$TEST_REPO/Tests/TestTests.swift"
cd "$TEST_REPO"
git init >/dev/null 2>&1
git add . >/dev/null 2>&1
git commit -m "init" >/dev/null 2>&1

output=$("$CALCULATE_SCRIPT" "$TEST_REPO" 2>/dev/null)
if echo "$output" | jq -e '.score' >/dev/null 2>&1; then
  echo "  ✅ Script produces valid JSON for single repo"
  ((PASS++))
else
  echo "  ❌ Script failed to produce valid JSON for single repo"
  ((FAIL++))
fi

echo ""
echo "========================================"
echo "Results: $PASS passed, $FAIL failed"
echo "========================================"

if (( FAIL > 0 )); then
  exit 1
fi
