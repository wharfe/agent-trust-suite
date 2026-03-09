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

When working across repos, check sibling directories: `../agentcontract/`, `../agent-trust-telemetry/`, `../trustbundle/`, `../agentbond/`.
**Always inspect actual source before writing about any component.** Do not fabricate API details.

| Repo | Role | Layer | Language | Source |
|------|------|-------|----------|--------|
| agentcontract | Contract definition & validation | Before | Node.js | https://github.com/wharfe/agentcontract |
| agent-trust-telemetry | Runtime trust observation | During | Python | https://github.com/wharfe/agent-trust-telemetry |
| trustbundle | Evidence trail packaging | After | Node.js | https://github.com/wharfe/trustbundle |
| agentbond | Authorization substrate (MCP Server) | Substrate | Node.js | https://github.com/wharfe/agentbond |

## Rules for Working in This Repository

- **No application code.** This repo contains only documentation, diagrams, and demo designs.
- **No package.json or CLI scaffolding.** Thin CLI implementation location is TBD (Phase 2).
- **Do not use "prove" or "proof" in external-facing docs.** Use "verify", "evidence", "observable", "verifiable" instead. The current tools provide verification and evidence, not cryptographic proof.
- **Do not copy STRATEGY.md content verbatim into external docs.** Rephrase strategic language (GTM, noise, first-mover, competition) into calm, specific, external-appropriate wording.
- **Do not name specific competing products** (e.g., OpenClaw) as the problem statement. Frame issues as general challenges in the multi-agent ecosystem.
- **agentbond should be introduced as background infrastructure**, not the front-facing entry point. The 3-layer model (contract → telemetry → bundle) is the primary narrative.
- **Be honest about implementation status.** Mark unimplemented features as "planned" or "not yet available". Do not fabricate API details, npm package names, or CLI commands.
- **External-facing documents (README, AGENTS.md, architecture.md) must be written in English.**
- **Code comments must be written in English.**
- **Commit messages follow Conventional Commits format.**
- **Each sibling repo is its own git repository.** Commit changes within the respective repo directory.

## Internal-Only Documents (gitignored)

These files live under `docs/` and are excluded from git. They guide strategy and execution but must not be exposed externally or copied verbatim into public-facing docs.

| Document | Purpose |
|----------|---------|
| `docs/STRATEGY.md` | Strategic positioning, market context, guiding principles. **Never expose externally. Never copy verbatim into README.** |
| `docs/DECISIONS.md` | Settled decisions from design discussions. **Do not re-debate these.** |
| `docs/WORKPLAN.md` | Phased cross-repo work plan. Check here for task sequence. |
| `docs/CLAUDE_CODE_INSTRUCTIONS.md` | Original task instructions (historical reference). |
| `docs/oss-dev-guidelines.md` | Development conventions reference. |

## How to Start Working

1. **Read this CLAUDE.md first** (you're here).
2. **Read `docs/STRATEGY.md`** for strategic context (why things are structured this way).
3. **Read `docs/DECISIONS.md`** for settled decisions (don't re-debate).
4. **Read `docs/WORKPLAN.md`** for current phase and task sequence.
5. **Inspect sibling repos** (`../agentcontract/`, etc.) to understand actual implementation state before writing about them.

## File Creation Guidelines

### README.md — Human-readable overview

Goal: A first-time visitor understands "3-layer trust suite" within 30 seconds.

- Tagline → What this suite helps you verify → 3 Layers → Quick Start → Why → Architecture → Status
- **Quick Start has two tiers:**
  - **Today:** Links to each repo's README + minimal try-it-now steps (only what actually works)
  - **Coming Soon:** Future thin CLI experience (mark CLI name as TBD)
- Keep it short. 2-3 scrolls max.
- agentbond appears after the 3-layer explanation, introduced as supporting infrastructure.

### AGENTS.md — AI agent navigation map

Goal: An LLM can read this and determine which repo to use, how to install it, and what to expect.

Each component entry follows this template:
```
## <component name>
- Does: ...
- Does not: ...
- Install: (actual command, or "Not yet published. Use source repository directly.")
- Input: (actual format, or "See source for current interface.")
- Output: (actual format, or "See source for current interface.")
- Dependencies: ...
- Suite position: Layer N — Before/During/After
- Try first: (actual command, or "See repository README for current entrypoint.")
- Status: Implemented / Partial / Planned
- Source: <github url>
```

Include a suite-level dependency graph.

### docs/architecture.md — Component diagram and data flow

**This is a diagram explanation, not a philosophy document.**

Include:
- Expanded version of the 3-layer diagram from README
- Input/output relationships between the 4 repos
- Before → During → After data flow
- Where agentbond connects as substrate

Do not include: lengthy design philosophy, strategic reasoning, or market analysis.

### demo/README.md — Demo scenario design

Document the design for a single demo scenario (30-90 seconds). No implementation code yet.

## Quality Checklist

Before considering any external-facing document complete:

- [ ] A reader understands "3-layer trust suite" within 30 seconds
- [ ] No "prove" / "proof" in external text
- [ ] No STRATEGY.md vocabulary (GTM, noise, first-mover) in external text
- [ ] AGENTS.md install/try-first entries are verified against actual repos (or use honest fallback)
- [ ] Implementation status is accurate (no fabricated details)
- [ ] No specific product named as the problem (general multi-agent challenges only)
- [ ] agentbond is introduced as background, not the lead
- [ ] No package.json or CLI code has been created in this repo

## Key Documents (Public)

- `README.md` — Start here for the human-readable overview
- `AGENTS.md` — Structured component map for AI agents
- `docs/architecture.md` — Data flow between the 4 components
- `demo/README.md` — Demo scenario design
