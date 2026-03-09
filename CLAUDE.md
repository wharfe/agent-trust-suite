# CLAUDE.md — agent-trust-suite

## About This Repository

This is the **umbrella repository** for Agent Trust Suite — an open-source trust infrastructure for multi-agent systems.

**This repo is a documentation and landing point, not an executable package.**
It does not contain application code, package.json, or CLI tooling.

## Repository Structure

```
agent-trust-suite/
├── README.md            # Human-readable overview (the landing page)
├── AGENTS.md            # AI agent navigation map (structured for LLM consumption)
├── CLAUDE.md            # This file — instructions for Claude Code
├── LICENSE              # MIT
├── docs/
│   ├── architecture.md  # Component diagram and data flow (not a philosophy doc)
│   └── ...
└── demo/
    └── README.md        # Demo scenario design (implementation in Phase 2)
```

## Suite Components (4 Repositories)

| Repo | Role | Language | Source |
|------|------|----------|--------|
| agentcontract | Contract definition & validation | Node.js | https://github.com/wharfe/agentcontract |
| agent-trust-telemetry | Runtime trust observation | Python | https://github.com/wharfe/agent-trust-telemetry |
| trustbundle | Evidence trail packaging | Node.js | https://github.com/wharfe/trustbundle |
| agentbond | Authorization substrate (MCP Server) | Node.js | https://github.com/wharfe/agentbond |

## Rules for Working in This Repository

- **No application code.** This repo contains only documentation, diagrams, and demo designs.
- **No package.json or CLI scaffolding.** Thin CLI implementation location is TBD.
- **Do not use "prove" or "proof" in external-facing docs.** Use "verify", "evidence", "observable", "verifiable" instead. The current tools provide verification and evidence, not cryptographic proof.
- **Do not copy STRATEGY.md content verbatim into external docs.** Rephrase strategic language into calm, specific, external-appropriate wording.
- **Do not name specific competing products** (e.g., OpenClaw) as the problem statement. Frame issues as general challenges in the multi-agent ecosystem.
- **agentbond should be introduced as background infrastructure**, not the front-facing entry point. The 3-layer model (contract → telemetry → bundle) is the primary narrative.
- **Be honest about implementation status.** Mark unimplemented features as "planned" or "not yet available". Do not fabricate API details.
- **External-facing documents (README, AGENTS.md, architecture.md) must be written in English.**
- **Code comments must be written in English.**
- **Commit messages follow Conventional Commits format.**

## Key Documents

- `README.md` — Start here for the human-readable overview
- `AGENTS.md` — Structured component map for AI agents
- `docs/architecture.md` — Data flow between the 4 components
- `demo/README.md` — Demo scenario design

## Internal-Only Documents (gitignored)

- `docs/STRATEGY.md` — Strategic positioning (never expose externally)
- `docs/CLAUDE_CODE_INSTRUCTIONS.md` — Original task instructions
- `docs/oss-dev-guidelines.md` — Development conventions reference
