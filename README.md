# Agent Trust Suite

> Trust infrastructure for multi-agent systems.
> Define contracts. Observe behavior. Verify traces.

As multi-agent systems grow through protocols like [A2A](https://github.com/google/A2A) and [MCP](https://modelcontextprotocol.io/), interoperability is advancing rapidly — but the trust layer remains thin. Agents can talk to each other, but there is no standard way to verify that they behave as expected.

**Agent Trust Suite** is an open-source collection of tools that makes agent behavior **observable and verifiable** across the execution lifecycle.

## What This Suite Helps You Verify

- That agents act within pre-agreed contracts
- That deviations are detected in real time during execution
- That verifiable evidence trails remain after execution

## 3 Layers

```
┌─────────────────────────────────────────────────────────┐
│  Before Execution                                       │
│  agentcontract — Define expected behavior as contracts  │
├─────────────────────────────────────────────────────────┤
│  During Execution                                       │
│  agent-trust-telemetry — Observe trust risks in real    │
│  time                                                   │
├─────────────────────────────────────────────────────────┤
│  After Execution                                        │
│  trustbundle — Preserve tamper-evident evidence trails   │
└─────────────────────────────────────────────────────────┘
        ▲
        │  Authorization Substrate
        │
  agentbond — Shared governance infrastructure
  powering authorization, intent tracking, and contracts
  across all three layers (MCP Server / SDK)
```

## Quick Start

### Today

Each tool can be used independently. Pick the layer relevant to your use case:

**agentcontract** (Node.js) — Define and validate agent behavior contracts

```bash
npm install -g agentcontract
agentcontract init --name my-agent
agentcontract run my-agent.contract.yaml
```

**agent-trust-telemetry** (Python) — Detect instruction contamination across agent traces

```bash
pip install agent-trust-telemetry
att evaluate message.json
att stream --input trace.jsonl
```

**trustbundle** (Node.js) — Package execution traces into tamper-evident bundles

```bash
npm install -g trustbundle
trustbundle init
trustbundle build
trustbundle verify
```

**agentbond** (Node.js monorepo) — Governance infrastructure with MCP Server

```bash
git clone https://github.com/wharfe/agentbond.git
cd agentbond && pnpm install && pnpm build
```

### Coming Soon

A unified CLI experience for running cross-layer trust verification in a single command. CLI name and implementation details are not yet finalized.

## Architecture

See [docs/architecture.md](docs/architecture.md) for the detailed data flow between components.

```mermaid
graph TB
    subgraph "Before"
        AC[agentcontract<br/>Contract Definition & Validation]
    end
    subgraph "During"
        ATT[agent-trust-telemetry<br/>Runtime Trust Observation]
    end
    subgraph "After"
        TB[trustbundle<br/>Evidence Packaging]
    end
    subgraph "Substrate"
        AB[agentbond<br/>Authorization & Governance]
    end

    AC -->|"contract scope"| ATT
    ATT -->|"trace data"| TB
    AB -.->|"auth tokens<br/>intent records<br/>contract lifecycle"| AC
    AB -.->|"authorization decisions"| ATT
    AB -.->|"audit records"| TB
```

## Status

| Repository | Version | Stage | Language |
|---|---|---|---|
| [agentcontract](https://github.com/wharfe/agentcontract) | 0.1.0 | MVP — API may change | Node.js |
| [agent-trust-telemetry](https://github.com/wharfe/agent-trust-telemetry) | 0.1.0 | Alpha — MVP phase complete | Python |
| [trustbundle](https://github.com/wharfe/trustbundle) | 0.1.0 | MVP — digest-based integrity | Node.js |
| [agentbond](https://github.com/wharfe/agentbond) | 0.1.0 | MVP — 17 MCP tools available | Node.js |

> All components are in early development. APIs and interfaces may change.

## Contributing

Contributions are welcome! Each repository accepts issues and pull requests independently.

For suite-level discussions (cross-repo architecture, new layer proposals, demo scenarios), please use this repository's [Issues](https://github.com/wharfe/agent-trust-suite/issues).

## License

[MIT](LICENSE)
