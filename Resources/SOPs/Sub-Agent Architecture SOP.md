# Sub-Agent Architecture SOP

**Status:** Active
**Owner:** @{Orchestrator}
**Last verified:** 2026-07-01

## Constraint

Claude Code does not surface the `Agent` tool to sub-agents at runtime, regardless of what the persona's YAML frontmatter declares. **Sub-agents are depth-1 only — they cannot recursively dispatch further sub-agents.** Verified empirically 2026-05-26 by direct dispatch.

This is a Claude Code platform constraint, not a configuration bug. It cannot be worked around with frontmatter, settings, or skill instructions.

## Implications

- A persona dispatched via `Agent` cannot itself call `Agent`.
- The Senior Adviser (@{SeniorAdviser}) is dispatched the same way as any other persona — only the Orchestrator can invoke him.
- Skills like `dispatching-parallel-agents` only execute at the Orchestrator level. Personas that list this skill in their "Skills I Reach For" section can describe fan-out logic, but must return a fan-out spec to the Orchestrator rather than attempting the dispatch.

## Two-Wave Dispatch Pattern

For research-heavy plans the Orchestrator runs dispatch in two waves:

- **Wave A — raw research.** Orchestrator dispatches data-gathering sub-agents in parallel — single message, multiple `Agent` calls.
- **Wave B — synthesis.** Orchestrator dispatches synthesis personas in parallel (e.g. @{MarketResearchSpecialist}, @{CompetitiveIntelligenceSpecialist}, @{SeniorResearcher}), feeding each their relevant Wave A returns as context.

The fan-out tree is always one level wide × N branches, never two levels deep.

## Fan-Out Spec Handoff

If a persona's brief calls for parallel sub-agent dispatch, the persona must:

1. Compose a **fan-out spec** — list of subagent_types + per-agent prompts.
2. Return the spec to the Orchestrator with `"Cannot dispatch; returning fan-out spec for Orchestrator dispatch."`
3. Wait for the Orchestrator to run the dispatch and route returns back.

Personas must **never** silently downgrade to solo desk synthesis when a brief specified sub-agent dispatch. Flag the limitation explicitly in the deliverable.

## Web Fetch & Visual Eval for Sub-Agents

> **Annotation (correction).** Earlier revisions of this section stated that sub-agents "cannot" fetch live web content because the redirect target was unreachable at runtime. Empirical re-verification (2026-07-01, see Change Log) found that claim false: `WebFetch`, the `ctx_*` MCP tools, and Playwright's `browser_*` tools are deferred but technically reachable from inside a dispatched `Agent`. The constraint below is corrected from "technically impossible" to a **policy stance** — capability exists, self-service by a persona is prohibited, and the prohibition is enforced behaviourally (see **Enforcement** below).

**Policy.** Personas **must not** attempt to fetch live web content or drive a browser themselves, even where the underlying tool is technically reachable. A dispatched persona that needs live URL content or a rendered visual check requests it through its fan-out spec; the Orchestrator supplies it from the main session. This is an operative directive, not a suggestion of convenience — the two lanes below are the only sanctioned paths.

**Enforcement.** The guardrail is behavioural, not config-level — no deny rule or hook covers `WebFetch`, `ctx_fetch_and_index`, or `browser_*`. Two layers catch persona self-browsing at the point of attempt, both observed in the 2026-07-01 empirical re-verification (see Change Log and `Vault/Memory/tool-exceptions.md`): restricted personas asked to fetch or navigate on their own refuse the request as a boundary violation, and the auto-mode classifier independently blocked a dispatch that attempted it. Treat this as a live guardrail, and as the reason the config allow-list alone is not the whole story.

**Scope note.** The refusal/classifier boundary above applies to **sub-agent dispatch only**. The Orchestrator running `ctx_*` tools or Playwright directly on the **main session** is unaffected by it and is, in fact, the sanctioned mechanism both lanes below depend on. Do not read the guardrail as reaching main-session Orchestrator activity — it doesn't. The main-session `WebFetch(domain:…)` grants in `.claude/settings.json` are a context-mode-absent fallback — inert while the plugin is active.

**Lane A — research / URL-read.** When a dispatched persona needs the contents of a live page:

1. The persona names the required URLs in its **fan-out spec** (see below) rather than attempting any fetch itself.
2. The Orchestrator, on the main session, runs `ctx_fetch_and_index(url, source)` for each URL — then `ctx_search(queries)` to pull relevant passages, or `ctx_execute(language, code)` for targeted extraction (`console.log` only what's needed).
3. The Orchestrator passes the indexed excerpts into the sub-agent's prompt as context.

**Lane B — visual pixel-test / rendered eval.** When a dispatched persona (e.g. @{WebflowDeveloper}, @{UXUIDesigner}, @{QAComplianceReviewer}) needs to judge a rendered UI, layout, or visual output rather than read text:

1. The persona names the URL or artefact to render and what it needs judged in its fan-out spec, rather than attempting to drive a browser itself.
2. The Orchestrator, on the main session, runs Playwright (`browser_navigate` + `browser_take_screenshot`) to render the target.
3. The Orchestrator passes the resulting screenshot image into the dispatched persona's prompt. The persona performs the visual judgement; it never touches the browser.

Render happens above the dispatch boundary; judgement happens within it. Both lanes keep web/browser access a privileged main-session pre-step — consistent with the depth-1 architecture, where the Orchestrator already owns the operations sub-agents cannot (by policy) perform themselves.

> Personas must **never** silently skip required live data or fabricate it when blocked. Flag the missing fetch or render in the fan-out spec so the Orchestrator supplies it.

## Frontmatter Rule

Persona YAML frontmatter must **not** list `Agent` under `tools:`. The grant is non-functional and listing it creates false expectations. The same applies to `WebFetch`, `ctx_*`, and Playwright `browser_*` tools: even though Lane A/B above establish they are technically reachable by a dispatched persona, listing them in frontmatter would misrepresent a policy-restricted capability as a sanctioned grant. `tool-exceptions.md` stays empty on this basis. See [Persona Template SOP](Persona%20Template%20SOP.md) for canonical tool baseline.

## `improve` and read-only meta-skills

The `improve` audit skill (`.claude/skills/improve/`) is strictly read-only on source and fans out its own parallel sub-agents (Phase 2). It runs on the **Orchestrator session as a meta-operation — never routed to a persona.** This is the depth-1 reason, not a convenience: a routed persona running `improve` would attempt a forbidden depth-2 dispatch, so the only legal home for it is the Orchestrator's own session.

Because it never mutates source, and its `Vault/Plans/` output is an internal planning artefact (git-ignored) rather than a client Deliverable, that output does not move to `03 Deliverables/` and is exempt from the QA Gate. An optional Advisor checkpoint on the audit's prioritisation is available when wanted.

This differs from the `/teach` carve-out: `/teach` is delegatable work the Orchestrator performs inline; `improve` is a meta-operation that was never delegatable to begin with. CLAUDE.md § Orchestrator-Only Operations carries the operative one-liner; this section is the rationale.

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

- **2026-07-01** — Re-verified the web-fetch constraint and reframed it from technical impossibility to an enforced policy stance; section split into Lane A (research fetch) and Lane B (visual eval); Frontmatter Rule extended to `WebFetch`/`ctx_*`/`browser_*`. Authority: @{SeniorAdviser} Checkpoint-A ruling, 2026-07-01. Detail: § Web Fetch & Visual Eval, which this entry summarised.
- **2026-06-16** — Added "Web Fetch for Sub-Agents" section. Documented that `context-mode` hard-blocks `WebFetch` with no opt-out and sub-agents lack the `ctx_*` redirect target; codified the Orchestrator-pre-fetch pattern (`ctx_fetch_and_index` on main session, excerpts passed into sub-agent prompts). CLAUDE.md § Sub-Agent Depth updated with the rule; SOP added to SOPs README index.
- **2026-05-26** — SOP created. Constraint discovered during Lumen demo dispatch. Six personas patched (Reid, Kai, Ryan, Odin, Axel, Casey); CLAUDE.md updated with stub; Persona Template SOP updated to forbid `Agent` in frontmatter.
