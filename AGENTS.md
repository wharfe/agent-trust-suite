# Agent Trust Suite — Agent Navigation Map

> This document is for AI agents (Claude Code, Cursor, agent runners, etc.)
> to quickly understand each component's role, interface, and current state.

## Suite Overview

Agent Trust Suite provides trust infrastructure for multi-agent systems in 3 layers + 1 substrate:

```
Before:  agentcontract         → Define expected behavior
During:  agent-trust-telemetry → Observe trust risks
After:   trustbundle           → Preserve evidence trails
Base:    agentbond             → Authorization & governance substrate
```

## Dependency Graph

```
agentbond (substrate)
  ├── agentcontract (uses @agentbond/contract for scope definitions)
  ├── agent-trust-telemetry (independent, can consume agentbond audit records)
  └── trustbundle (has agentbond adapter for audit record ingestion)
```

Each component can be used independently. agentbond integration is optional.

---

## agentcontract

- **Does:** Define agent behavior contracts as YAML specs, then validate agent outputs against them. Supports pattern matching, JSON schema validation, and LLM-as-judge assertions.
- **Does not:** Runtime monitoring or log collection. It validates outputs after generation, not during execution.
- **Install:** `npm install -g agentcontract` (v0.1.0)
- **CLI:**
  - `agentcontract init --name <name>` — Scaffold a new contract file
  - `agentcontract run <file>.contract.yaml` — Run contract validation
- **Programmatic:**
  ```typescript
  import type { Contract, RunResult } from "agentcontract";
  ```
- **Input:** YAML contract files (`.contract.yaml`)
- **Output:** `RunResult` with pass/fail status per assertion
- **Assertion types:** `contains_pattern`, `not_contains_pattern`, `scope_compliant` (LLM-as-judge), `json_schema`
- **Dependencies:** `@anthropic-ai/sdk`, `ajv`, `commander`, `js-yaml`
- **LLM adapter:** Anthropic only (MVP)
- **Node:** >=18
- **Suite position:** Layer 1 — Before execution
- **Status:** MVP (0.1.0) — API may change without notice
- **Source:** https://github.com/wharfe/agentcontract

---

## agent-trust-telemetry

- **Does:** Middleware for detecting instruction contamination and trust policy violations in agent-to-agent communication. Evaluates messages against trust schemas, produces risk scores, and generates reports.
- **Does not:** Modify or block agent actions. It is an observation layer, not an enforcement layer.
- **Install:** `pip install agent-trust-telemetry` (v0.1.0-alpha) — if published; otherwise install from source: `pip install -e ".[dev]"`
- **CLI:**
  - `att evaluate --message <message.json>` — Evaluate a single message
  - `att evaluate --stream <trace.jsonl>` — Process JSONL message streams
  - `att report --input <evaluations.jsonl>` — Generate trust reports
  - `att quarantine list|release|clear` — Manage quarantined messages
- **Input:** JSON messages or JSONL streams conforming to trust telemetry schema
- **Output:** Trust evaluation results with risk scores and violation classifications
- **Violation types:** 5 violation categories + anomaly indicators
- **Dependencies:** `jsonschema` >=4.20.0, `PyYAML` >=6.0
- **Optional:** OpenTelemetry integration, LangGraph callback handler
- **Python:** >=3.10
- **License:** Apache-2.0
- **Suite position:** Layer 2 — During execution
- **Status:** Alpha (0.1.0) — MVP phase complete, deterministic pattern matching
- **Source:** https://github.com/wharfe/agent-trust-telemetry

---

## trustbundle

- **Does:** Package agent execution traces into tamper-evident bundles with digest-based integrity verification. Supports multiple input adapters.
- **Does not:** Cryptographic signing or key management (planned for future releases).
- **Install:** `npm install -g trustbundle` (v0.1.0)
- **CLI:**
  - `trustbundle init` — Initialize a bundle workspace
  - `trustbundle build` — Build a trust bundle from traces
  - `trustbundle verify` — Verify bundle integrity
  - `trustbundle show` — Display bundle contents in human-readable form
- **Programmatic:**
  ```typescript
  import { /* see source */ } from "trustbundle";
  ```
- **Input adapters:**
  - Generic JSONL (implemented)
  - agentbond audit records (implemented)
  - OpenTelemetry spans (planned)
- **Output:** Trust bundle with integrity digests
- **Dependencies:** `commander`
- **Node:** >=20
- **Suite position:** Layer 3 — After execution
- **Status:** MVP (0.1.0) — digest-based integrity only
- **Source:** https://github.com/wharfe/trustbundle

---

## agentbond

- **Does:** Governance infrastructure for autonomous AI agents. Provides authorization (token-based permissions, budget control, delegation), intent tracking, contract lifecycle management, and settlement. Exposes 17 tools via MCP Server.
- **Does not:** Define behavioral contracts (that's agentcontract) or collect runtime telemetry (that's agent-trust-telemetry).
- **Install:** Published to npm.
  ```bash
  npx @agentbond/mcp-server              # run MCP server directly
  npm install @agentbond/auth             # use as library
  ```
- **Packages:**
  - `@agentbond/core` (v0.1.1) — Type definitions and shared interfaces
  - `@agentbond/auth` (v0.1.1) — Token-based authorization engine
  - `@agentbond/intent` (v0.1.1) — Intent tracking and evidence
  - `@agentbond/contract` (v0.1.0) — Contract lifecycle management
  - `@agentbond/settlement` (v0.1.0) — Settlement execution with provider registry
  - `@agentbond/mcp-server` (v0.1.2) — MCP server exposing all layers
- **MCP Server:** 17 tools exposed via Model Context Protocol
- **Authorization codes:** `ALLOWED`, `TOKEN_EXPIRED`, `BUDGET_EXCEEDED`, etc.
- **Build:** pnpm workspaces + turborepo
- **Node:** >=20
- **Suite position:** Authorization substrate — powers all three layers
- **Status:** MVP (0.1.0) — core governance primitives implemented
- **Source:** https://github.com/wharfe/agentbond

---

## Recommended Exploration Order

1. **agentcontract** — Start here to understand contract definition
2. **trustbundle** — See how execution traces are packaged
3. **agent-trust-telemetry** — Explore runtime trust observation
4. **agentbond** — Understand the governance substrate

## Suite-Level Resources

- Suite overview: [README.md](README.md)
- Architecture details: [docs/architecture.md](docs/architecture.md)
- Demo scenario design: [demo/README.md](demo/README.md)
