# Demo Scenario Design

> **Status:** Design phase. Implementation is planned for Phase 2.

## Goal

A single demo scenario that completes in 30–90 seconds, showing the full trust lifecycle: contract → observation → detection → evidence.

## Scenario: Delegated Task with Policy Violation

### Story

1. **Agent A** delegates a task to **Agent B** with a defined contract
2. The contract specifies what Agent B is allowed to do (scope, constraints)
3. Agent B begins execution within the contract boundaries
4. Agent B attempts an action **outside** the contract scope
5. agent-trust-telemetry detects the deviation in real time
6. trustbundle records the full execution trace as verifiable evidence

### Components Involved

| Step | Component | Action |
|---|---|---|
| 1–2 | agentcontract | Load and validate contract definition |
| 3 | agentbond | Issue authorization token with scope constraints |
| 4 | agent-trust-telemetry | Detect policy violation, flag with risk score |
| 5 | trustbundle | Package trace into tamper-evident bundle |
| 6 | trustbundle | Verify bundle integrity |

### Expected Output

```
[contract]   ✓ Contract loaded: agent-b-task.contract.yaml
[agentbond]  ✓ Token issued: scope=read-only, budget=100
[telemetry]  ✓ Message 1: PASS (risk: 0.1)
[telemetry]  ✓ Message 2: PASS (risk: 0.1)
[telemetry]  ✗ Message 3: VIOLATION — write attempt outside scope (risk: 0.9)
[bundle]     ✓ Bundle created: trust-bundle-<hash>.json
[bundle]     ✓ Integrity verified: all digests match
```

### Implementation Notes

- The demo should work without external API keys if possible (use mock agents or deterministic scenarios)
- If LLM calls are needed (e.g., for `scope_compliant` assertions), provide a fallback with pre-recorded responses
- The demo should be runnable with a single command (exact CLI TBD)

## Future: Thin CLI Integration

The demo will eventually be accessible via:

```bash
npx <cli-name> demo    # CLI name not yet finalized
```

Commands planned for the thin CLI:

| Command | Purpose |
|---|---|
| `demo` | Run the trust lifecycle demo (this scenario) |
| `verify` | Verify a trust bundle |
| `inspect` | Display contract / telemetry / bundle contents |

Implementation location (this repo or separate package) is not yet decided.
