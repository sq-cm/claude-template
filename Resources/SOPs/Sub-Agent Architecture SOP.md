# Sub-Agent Architecture SOP

**Status:** Active
**Owner:** @{Orchestrator}
**Last verified:** 2026-05-26

## Constraint

Claude Code does not surface the `Agent` tool to sub-agents at runtime, regardless of what the persona's YAML frontmatter declares. **Sub-agents are depth-1 only — they cannot recursively dispatch further sub-agents.** Verified empirically 2026-05-26 by direct dispatch (sub-agent reported `"Tools available in this invocation: Read, Write, Edit, Bash, advisor. No Agent tool exists."`).

> **Annotation (correction).** That quoted string is a 2026-05-26 capture and reflects the tool set of that dispatch, not the current baseline. The current six-tool baseline is `Read, Write, Edit, Glob, Grep, Bash` (no `advisor` tool) per the [Persona Template SOP](Persona%20Template%20SOP.md). The quote is preserved verbatim as evidence; the load-bearing point it establishes — that no `Agent` tool exists for sub-agents — still holds.

This is a Claude Code platform constraint, not a configuration bug. It cannot be worked around with frontmatter, settings, or skill instructions.

## Implications

- A persona dispatched via `Agent` cannot itself call `Agent`.
- The Senior Adviser (@{SeniorAdviser}) is dispatched the same way as any other persona — only the Orchestrator can invoke him.
- Skills like `dispatching-parallel-agents` only execute at the Orchestrator level. Personas that list this skill in their "Skills I Reach For" section can describe fan-out logic, but must return a fan-out spec to the Orchestrator rather than attempting the dispatch.

## Two-Wave Dispatch Pattern

For research-heavy plans the Orchestrator runs dispatch in two waves:

- **Wave A — raw research.** Orchestrator dispatches data-gathering sub-agents in parallel (e.g. `voltagent-research:market-researcher`, `voltagent-research:competitive-analyst`, `voltagent-research:data-researcher`). Single message, multiple `Agent` calls.
- **Wave B — synthesis.** Orchestrator dispatches synthesis personas in parallel (Reid, Kai, Ryan, etc.), feeding each their relevant Wave A returns as context.

The fan-out tree is always one level wide × N branches, never two levels deep.

## Fan-Out Spec Handoff

If a persona's brief calls for parallel sub-agent dispatch, the persona must:

1. Compose a **fan-out spec** — list of subagent_types + per-agent prompts.
2. Return the spec to the Orchestrator with `"Cannot dispatch; returning fan-out spec for Orchestrator dispatch."`
3. Wait for the Orchestrator to run the dispatch and route returns back.

Personas must **never** silently downgrade to solo desk synthesis when a brief specified sub-agent dispatch. Flag the limitation explicitly in the deliverable.

## Web Fetch for Sub-Agents

Sub-agents cannot fetch live web content. Two compounding reasons:

1. **The `context-mode` plugin hard-blocks `WebFetch`.** Its PreToolUse hook (`hooks/core/routing.mjs`) denies `WebFetch` unconditionally and redirects to `ctx_fetch_and_index`. There is no env var, config file, or per-tool allowlist to disable it, and a `deny` from a plugin hook cannot be overridden by a counter-hook in vault settings. The block lives in the per-machine plugin install (`~/.claude/plugins/`), not in this repo — it is version-pinned and wiped on plugin upgrade, so patching it is not durable.
2. **Sub-agents lack the redirect target.** The `ctx_*` MCP tools the block points to are only available on the main (Orchestrator) session, not inside a dispatched `Agent`. So the redirect is unreachable for a sub-agent — a dead end either way.

**Pattern — Orchestrator pre-fetches.** When a dispatched persona needs web content:

1. The persona names the required URLs in its **fan-out spec** (see below) rather than attempting any fetch itself.
2. The Orchestrator, on the main session, runs `ctx_fetch_and_index(url, source)` for each URL — then `ctx_search(queries)` to pull relevant passages, or `ctx_execute(language, code)` for targeted extraction (`console.log` only what's needed).
3. The Orchestrator passes the indexed excerpts into the sub-agent's prompt as context.

This keeps web fetch a privileged main-session pre-step — consistent with the depth-1 architecture, where the Orchestrator already owns the operations sub-agents cannot perform. It survives plugin upgrades and ships through the vault git tree with no per-machine patching.

> Personas must **never** silently skip required live data or fabricate it when blocked. Flag the missing fetch in the fan-out spec so the Orchestrator supplies it.

## Frontmatter Rule

Persona YAML frontmatter must **not** list `Agent` under `tools:`. The grant is non-functional and listing it creates false expectations. See [Persona Template SOP](Persona%20Template%20SOP.md) for canonical tool baseline.

## Verification Procedure

To re-test the constraint (e.g. after a Claude Code version bump):

```
Agent(
  subagent_type: "<any persona>",
  prompt: "List the tools available to you. If 'Agent' is in your tool set, invoke it once with a trivial prompt and return the result. Otherwise return your tool list verbatim."
)
```

If the sub-agent returns a successful `Agent` invocation, depth-2 dispatch is now supported and this SOP should be updated.

## Change Log

- **2026-06-16** — Added "Web Fetch for Sub-Agents" section. Documented that `context-mode` hard-blocks `WebFetch` with no opt-out and sub-agents lack the `ctx_*` redirect target; codified the Orchestrator-pre-fetch pattern (`ctx_fetch_and_index` on main session, excerpts passed into sub-agent prompts). CLAUDE.md § Sub-Agent Depth updated with the rule; SOP added to SOPs README index.
- **2026-05-26** — SOP created. Constraint discovered during Lumen demo dispatch. Six personas patched (Reid, Kai, Ryan, Odin, Axel, Casey); CLAUDE.md updated with stub; Persona Template SOP updated to forbid `Agent` in frontmatter.
