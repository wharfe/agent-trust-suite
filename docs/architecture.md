# Architecture

## Overview

Agent Trust Suite consists of 4 components organized in 3 layers plus a shared substrate.

```
┌─────────────────────────────────────────────────────────────┐
│ Layer 1: Before Execution                                   │
│                                                             │
│   agentcontract                                             │
│   ┌───────────────────────────────────┐                     │
│   │ Input:  YAML contract definition  │                     │
│   │ Output: RunResult (pass/fail)     │                     │
│   │ Role:   Validate that agent       │                     │
│   │         outputs match contracts   │                     │
│   └───────────────────────────────────┘                     │
├─────────────────────────────────────────────────────────────┤
│ Layer 2: During Execution                                   │
│                                                             │
│   agent-trust-telemetry                                     │
│   ┌───────────────────────────────────┐                     │
│   │ Input:  JSON messages / JSONL     │                     │
│   │         streams                   │                     │
│   │ Output: Trust evaluation results  │                     │
│   │         with risk scores          │                     │
│   │ Role:   Detect instruction        │                     │
│   │         contamination and policy  │                     │
│   │         violations at runtime     │                     │
│   └───────────────────────────────────┘                     │
├─────────────────────────────────────────────────────────────┤
│ Layer 3: After Execution                                    │
│                                                             │
│   trustbundle                                               │
│   ┌───────────────────────────────────┐                     │
│   │ Input:  JSONL traces / agentbond  │                     │
│   │         audit records             │                     │
│   │ Output: Tamper-evident bundle     │                     │
│   │         with integrity digests    │                     │
│   │ Role:   Package execution traces  │                     │
│   │         as verifiable evidence    │                     │
│   └───────────────────────────────────┘                     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Substrate: agentbond                                        │
│                                                             │
│   ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│   │ @agentbond/ │  │ @agentbond/  │  │ @agentbond/      │  │
│   │ auth        │  │ intent       │  │ contract         │  │
│   │             │  │              │  │                  │  │
│   │ Token-based │  │ Action       │  │ Contract         │  │
│   │ authz,      │  │ reason       │  │ lifecycle        │  │
│   │ budget      │  │ tracking     │  │ management       │  │
│   │ control,    │  │              │  │                  │  │
│   │ delegation  │  │              │  │                  │  │
│   └─────────────┘  └──────────────┘  └──────────────────┘  │
│   ┌──────────────────┐                                     │
│   │ @agentbond/      │                                     │
│   │ settlement       │                                     │
│   │                  │                                     │
│   │ Settlement       │                                     │
│   │ execution with   │                                     │
│   │ provider         │                                     │
│   │ registry         │                                     │
│   └──────────────────┘                                     │
│                                                             │
│   Exposed as 17 MCP tools via Model Context Protocol        │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

```
1. Contract Definition
   ────────────────────
   Developer writes .contract.yaml
       │
       ▼
   agentcontract validates contract schema
       │
       ▼
   Contract scope may reference @agentbond/contract

2. Runtime Observation
   ────────────────────
   Agent executes actions
       │
       ▼
   agent-trust-telemetry intercepts messages
       │
       ▼
   Trust evaluation: risk scores + violation flags
       │
       ▼
   (Optional) OpenTelemetry export to observability platform

3. Evidence Packaging
   ────────────────────
   Execution traces (JSONL) + agentbond audit records
       │
       ▼
   trustbundle build
       │
       ▼
   Tamper-evident bundle with integrity digests
       │
       ▼
   trustbundle verify (integrity check)
```

## Cross-Component Integration Points

| From | To | Integration | Status |
|---|---|---|---|
| agentbond | agentcontract | Contract scope definitions via `@agentbond/contract` | Available |
| agentbond | trustbundle | Audit record adapter for bundle ingestion | Implemented |
| agent-trust-telemetry | OpenTelemetry | Span export to observability platforms | Optional |
| trustbundle | OpenTelemetry | Span ingestion as input adapter | Planned |

## Language Boundaries

- **Node.js ecosystem:** agentcontract, trustbundle, agentbond
- **Python ecosystem:** agent-trust-telemetry

The suite is designed to work across language boundaries. Integration happens through standard formats (JSON, JSONL, YAML) and protocols (MCP, OpenTelemetry).

## Future: Thin CLI

A unified CLI is planned to provide a single entry point across all layers. Design details are documented in [demo/README.md](../demo/README.md). Implementation location (this repo or a separate package) is not yet decided.
