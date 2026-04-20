# Repo Consultation SOP

How team members consult `Resources/Git/` repos for best-practice guidance before checkpoint-eligible work.

---

## When it applies

Repo consultation happens at **Checkpoint A** (pre-work) for any checkpoint-eligible task. It does not apply to:
- Lookups, roster checks, or single-line answers
- Meta-operations the Orchestrator handles directly
- Tasks where the next action is dictated entirely by tool output just read

---

## How to consult

1. **Identify relevant repos** — read `Resources/Git/INDEX.md`. Match the task's domain to tags in the index. Select **max 3 repos**.
2. **Read the relevant content** — README and any directly applicable reference files in the selected repos.
3. **Apply findings** — integrate best-practice guidance into your approach before drafting.
4. **Narrate the consultation** — state which repos were checked and what was applied (e.g., "Checked `claude-code-best-practice` and `everything-claude-code` — following their hook structure pattern.").

---

## Conflict resolution

If repo guidance contradicts CLAUDE.md, an SOP, or a persona constraint:

1. **Do not silently override either source.**
2. **Pause the task.**
3. **Invoke @{OpusAdvisor}** with both the repo guidance and the conflicting instruction:

```
Agent(
  subagent_type: "general-purpose",
  model: "opus",
  description: "@{OpusAdvisor} — repo conflict resolution",
  prompt: "You are Odin — Opus Advisor. Respond in ≤100 words, enumerated steps, no explanations.

  Conflict: [repo name] recommends [X]. CLAUDE.md/SOP says [Y].
  Task context: [brief description]
  Question: Which takes precedence, and why?"
)
```

4. **Surface the conflict and the Opus Advisor's ruling to the user** before proceeding.
5. **Log the ruling** to `Vault/Memory/repo-conflicts.md` for precedent.

---

## Ruling log format (`Vault/Memory/repo-conflicts.md`)

```
## YYYY-MM-DD — [Task description]
- Repo: [repo-name]
- Conflict: [repo said X / CLAUDE.md said Y]
- Opus Advisor ruling: [ruling summary]
- Applied: [what was done]
```

---

## Index location

`Resources/Git/INDEX.md` — maintained by the Senior Researcher when new repos are added.
