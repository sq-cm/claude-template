# Repo Consultation SOP

How team members consult `Resources/Git/` repos **and `Resources/Refs/` doc references** for best-practice guidance before checkpoint-eligible work.

---

## When it applies

Repo consultation happens at **Checkpoint A** (pre-work) for any checkpoint-eligible task. It does not apply to:
- Lookups, roster checks, or single-line answers
- Meta-operations the Orchestrator handles directly
- Tasks where the next action is dictated entirely by tool output just read

An empty `INDEX.md` on a fresh clone makes consultation a narrated no-op — narrate the skip and proceed.

---

## How to consult

1. **Identify relevant repos** — read `Resources/Git/INDEX.md`. Match the task's domain to tags in the index. Select **max 3 repos**.
   Doc refs are found via `Resources/Refs/INDEX.md` (same max-3 budget shared across both indexes; match task domain to tags). Git = cloned repositories (code/patterns to read locally); Refs = indexed documentation URLs (retrieved via `ctx_search`; if the local knowledge base is empty on this machine, ask the Orchestrator/user to run `/import-ref` to re-fetch).
2. **Read the relevant content** — README and any directly applicable reference files in the selected repos.
3. **Apply findings** — integrate best-practice guidance into your approach before drafting.
4. **Narrate the consultation** — state which repos were checked and what was applied (e.g., "Checked `claude-code-best-practice` and `everything-claude-code` — following their hook structure pattern.").

---

## Conflict resolution

If repo guidance contradicts CLAUDE.md, an SOP, or a persona constraint:

1. **Do not silently override either source.**
2. **Pause the task and return the conflict to the Orchestrator.** The working persona never invokes @{SeniorAdviser} itself (depth-1 sub-agent rule).
3. **The Orchestrator dispatches @{SeniorAdviser}** — registered agent type, per the [Advisor Checkpoints SOP](Advisor%20Checkpoints%20SOP.md) § How to invoke the Senior Adviser — with both the repo guidance and the conflicting instruction, and the question: which takes precedence, and why?
4. **Surface the conflict and the Senior Adviser's ruling to the user** before proceeding.
5. **Log the ruling** to `Vault/Memory/repo-conflicts.md` for precedent.

The same escalation path applies verbatim to `Resources/Refs/` doc-ref guidance; log to the same `Vault/Memory/repo-conflicts.md` with `Repo:` replaced by `Ref:`.

---

## Ruling log format (`Vault/Memory/repo-conflicts.md`)

```
## YYYY-MM-DD — [Task description]
- Repo: [repo-name]
- Conflict: [repo said X / CLAUDE.md said Y]
- Senior Adviser ruling: [ruling summary]
- Applied: [what was done]
```

---

## Index location

`Resources/Git/INDEX.md` — maintained by the Senior Researcher when new repos are added.

`Resources/Refs/INDEX.md` — maintained by the Senior Researcher when new doc refs are imported (`/import-ref` appends rows; the Senior Researcher curates).
