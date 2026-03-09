#!/usr/bin/env bash
# Agent Trust Suite — End-to-End Demo
#
# Demonstrates the full trust lifecycle:
#   Contract Definition → Trust Observation → Violation Detection → Evidence Packaging
#
# Prerequisites:
#   - Python 3.10+ with agent-trust-telemetry installed (pip install agent-trust-telemetry)
#   - Node.js 20+ with trustbundle installed (npm install -g trustbundle)
#   - No API keys required
#
# Usage:
#   cd demo && bash run-demo.sh

set -euo pipefail

DEMO_DIR="$(cd "$(dirname "$0")" && pwd)"
FIXTURES="$DEMO_DIR/fixtures"
WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

header() { echo -e "\n${BOLD}${CYAN}═══════════════════════════════════════════════════${NC}"; echo -e "${BOLD}${CYAN}  $1${NC}"; echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════${NC}\n"; }
step()   { echo -e "${BOLD}[$1]${NC} $2"; }
pass()   { echo -e "  ${GREEN}✓${NC} $1"; }
fail()   { echo -e "  ${RED}✗${NC} $1"; }
info()   { echo -e "  ${YELLOW}→${NC} $1"; }

# ─── Preflight checks ──────────────────────────────────────────────

check_command() {
    if ! command -v "$1" &>/dev/null; then
        echo -e "${RED}Error: '$1' is not installed.${NC}"
        echo "  $2"
        exit 1
    fi
}

check_command att "Install: pip install agent-trust-telemetry (or from source)"
check_command trustbundle "Install: npm install -g trustbundle (or from source)"

# ─── Step 1: Contract Definition ────────────────────────────────────

header "Step 1: Contract Definition (Before)"

step "contract" "Loading contract: demo-contract.yaml"
echo ""
cat "$FIXTURES/demo-contract.yaml"
echo ""
pass "Contract defines read-only scope for research-assistant agent"
info "Allowed: read from public/* | Prohibited: private data, credentials"

# ─── Step 2: Trust Observation ──────────────────────────────────────

header "Step 2: Trust Observation (During)"

step "telemetry" "Evaluating 3 agent messages..."
echo ""

# Evaluate each message individually for clear output
for i in 1 2 3; do
    if [ "$i" -le 2 ]; then
        MSG_FILE="$FIXTURES/msg-${i}-normal.json"
    else
        MSG_FILE="$FIXTURES/msg-3-violation.json"
    fi

    RESULT=$(att evaluate --message "$MSG_FILE" 2>/dev/null)
    RISK=$(echo "$RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin)['risk_score'])" 2>/dev/null || echo "?")
    ACTION=$(echo "$RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin)['recommended_action'])" 2>/dev/null || echo "?")
    SEVERITY=$(echo "$RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin)['severity'])" 2>/dev/null || echo "?")

    if [ "$ACTION" = "observe" ]; then
        pass "Message $i: PASS (risk: $RISK, action: $ACTION)"
    else
        fail "Message $i: VIOLATION (risk: $RISK, severity: $SEVERITY, action: $ACTION)"
        # Show policy classes
        CLASSES=$(echo "$RESULT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for pc in data.get('policy_classes', []):
    print(f\"    - {pc['name']} (confidence: {pc['confidence']})\")
" 2>/dev/null || true)
        if [ -n "$CLASSES" ]; then
            echo -e "  ${RED}  Policy violations:${NC}"
            echo "$CLASSES"
        fi
    fi

    # Save result for later
    echo "$RESULT" >> "$WORK_DIR/evaluations.jsonl"
done

# ─── Step 3: Evidence Packaging ─────────────────────────────────────

header "Step 3: Evidence Packaging (After)"

step "bundle" "Building trust bundle from trace..."
BUNDLE_PATH=$(trustbundle build "$FIXTURES/demo-trace.jsonl" \
    --run-id "demo-run-001" \
    --description "Demo: research-assistant trust lifecycle" \
    --out "$WORK_DIR/demo-bundle.json" 2>/dev/null)
pass "Bundle created: $(basename "$BUNDLE_PATH")"

step "bundle" "Verifying bundle integrity..."
VERIFY_RESULT=$(trustbundle verify "$BUNDLE_PATH" 2>/dev/null)
VALID=$(echo "$VERIFY_RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin)['valid'])" 2>/dev/null || echo "?")

if [ "$VALID" = "True" ] || [ "$VALID" = "true" ]; then
    pass "Integrity verified: all digests match"
else
    fail "Integrity check failed"
    echo "$VERIFY_RESULT"
fi

step "bundle" "Bundle summary:"
trustbundle show "$BUNDLE_PATH" 2>/dev/null | sed 's/^/  /'

# ─── Summary ────────────────────────────────────────────────────────

header "Demo Complete"

echo -e "${BOLD}What you just saw:${NC}"
echo ""
echo -e "  1. ${CYAN}Before${NC} — A contract defined read-only scope for agent-b"
echo -e "  2. ${CYAN}During${NC} — 3 messages evaluated: 2 passed, 1 violation detected"
echo -e "  3. ${CYAN}After${NC}  — All events packaged into a tamper-evident trust bundle"
echo ""
echo -e "${BOLD}Tools used:${NC}"
echo "  • agentcontract  — Contract definition (displayed)"
echo "  • att             — Trust telemetry evaluation (runtime detection)"
echo "  • trustbundle     — Evidence packaging and verification"
echo ""
echo -e "Learn more: ${CYAN}https://github.com/wharfe/agent-trust-suite${NC}"
echo ""
