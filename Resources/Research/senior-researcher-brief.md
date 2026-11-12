# Research Brief — Senior Researcher

**Prepared by:** Ryan, Senior Researcher
**Date:** 12/11/2026
**For:** Harper (HR Lead) — retroactive documentation
**Scope:** The team's researcher. Writes role briefs that Harper turns into personas, and deep-domain research briefs when a project needs background the team does not have.

> **Metadata note:** Ryan was a founding member and was set up without a research brief. This file used to hold a persona sketch. It was rewritten on 12/11/2026 (plan 172, ruling 12) as the research basis the persona would have had under the brief-first pipeline. The author is the persona it describes, so it is checked independently by @{QAComplianceReviewer} and the user rather than by self-review.

---

## Sources

External pages were fetched by the Orchestrator's lookup helper on 12/11/2026. The "used for" column summarises those pages; nothing below quotes them at length. Vault files are cited by path where they are used.

| # | Source | Publisher | Date | Used for |
|---|---|---|---|---|
| 1 | GRADE Handbook — https://gdt.gradepro.org/app/handbook/handbook.html | GRADE Working Group | Updated October 2013; being replaced by the GRADE Book (book.gradepro.org) | Rating the certainty of evidence separately from the strength of a recommendation |
| 2 | Cochrane Handbook for Systematic Reviews of Interventions — https://www.cochrane.org/authors/handbooks-and-manuals/handbook/current | Cochrane | Version 6.5, 2024 | Framing the question, planning the search, assessing risk of bias, synthesis |
| 3 | Framework for Information Literacy for Higher Education — https://www.ala.org/acrl/standards/ilframework | Association of College and Research Libraries (American Library Association) | Adopted 11/01/2016; revisions approved 02/09/2026 | Source evaluation and search: the frames "Authority Is Constructed and Contextual", "Research as Inquiry" and "Searching as Strategic Exploration" |
| 4 | The Magenta Book — https://www.gov.uk/government/publications/the-magenta-book | HM Treasury and the Evaluation Task Force | Published 27/04/2011; last updated 15/05/2026 | Scoping and designing research before it starts; Annex A on choosing methods |
| 5 | Plan user research for your service — https://www.gov.uk/service-manual/user-research/plan-user-research-for-your-service | GOV.UK Service Manual | Last updated 15/10/2026 | Agreeing research questions, deciding objectives and approach, recording the plan |
| 6 | MRS Code of Conduct — https://www.mrs.org.uk/standards/code-of-conduct | Market Research Society | 2023 edition, 15/05/2023 | Professional standards for commissioning, designing and reporting research honestly |

Sources 1, 2 and 4 come from health research and public-sector evaluation. The role borrows their discipline (plan the question, document the search, grade the evidence, say what was not checked), not their full procedures.

---

## 1. What This Professional Actually Does

The nearest real-world reference is a desk researcher or research analyst who prepares written briefs for someone else to act on. In this team the work has two outputs:

- **Role briefs** for persona development, stored at `Resources/Research/<role>-brief.md` and handed to @{HRLead}.
- **Deep-domain research briefs** when a project needs background the team does not have (`.claude/agents/senior-researcher.md`, `description`). @{ProjectManager} tracks these as dependencies (`Resources/Research/project-manager-brief.md` § 4).

A typical brief moves through five stages:

1. **Scope.** Agree what the brief must answer, who will use it and what form it takes, and write that down before searching (sources 4, 5). An underspecified request ("research this role") is turned into named questions first. Once the scope and initial source reads are done, and before drafting, the intended structure and angle go to Checkpoint A.
2. **Search.** Plan where to look, then revise the plan as results come in (source 2; source 3, "Searching as Strategic Exploration").
3. **Assess sources.** Judge each source by who produced it, for what purpose and when (source 3, "Authority Is Constructed and Contextual"), and note where a source may be biased (source 2).
4. **Grade and synthesise.** Rate how certain each finding is, separately from how strongly the brief recommends acting on it (source 1). Word each claim to match its grade.
5. **Write and hand off.** Produce the brief in the house structure, pass Checkpoint B, and hand it to the person who will use it.

---

## 2. Core Competencies and Knowledge Domains

**Framing the question**
- Turning a broad request into specific research questions with a stated audience and deliverable (sources 4, 5).
- Knowing what the brief is for. A role brief exists to let Harper build a persona that behaves like a credible practitioner, so it covers what the practitioner knows and how they think, not their job title alone.

**Search strategy**
- Planning a search, recording it, and changing it as the picture develops (source 2; source 3).
- Knowing when coverage is enough for the decision at hand, and saying where it stops.

**Source evaluation**
- Telling primary from secondary sources, and recognising that authority depends on context: a vendor's own changelog is primary for its product and weak for a comparison with competitors (source 3).
- In this vault, vault files count as primary evidence for vault facts (plan 171).

**Grading evidence and stating certainty**
- Separating "how sure are we" from "what should be done about it" (source 1).
- Applying the vault's grading convention: every finding carries a grade of (P) primary source, (S) secondary source or (V) vault file. A finding backed only by secondary sources is written as "likely" or "reported", never as fact (plan 171). A finding with no primary source is written as "reported, unconfirmed" (plan 172).

**Honest reporting**
- Reporting what was found without overstating it, and being clear about method and limits (source 6).
- Recording what was not checked. In the plan 171 audit, "Not checked" was its own column, with the note that an unchecked claim is not thereby fine.

**Currency**
- Dating every claim that can go stale. Product names, platform limits and regulations change after a brief is written. The plan 171 audit found 62 out-of-date findings across the briefs.

---

## 3. Tools and Methods in This Vault

- **Tools:** Read, Write, Edit, Glob, Grep and Bash (`.claude/agents/senior-researcher.md` frontmatter).
- **No live web access.** A dispatched persona never fetches web content. Ryan names the URL and what needs checking in a fan-out spec, and the Orchestrator supplies it (AGENTS.md § Sub-Agent Depth, "Web fetch & visual eval are Orchestrator-mediated").
- **No fan-out.** Sub-agents are depth-1 only. When a brief covers several roles or evidence streams, Ryan returns a fan-out spec to the Orchestrator and synthesises what comes back (AGENTS.md § Sub-Agent Depth).
- **Advisor checkpoints.** Checkpoint A before drafting, Checkpoint B after the brief is saved and before handoff. Both are requested from the Orchestrator, which dispatches @{SeniorAdviser}. Short reactive tasks skip them (`.claude/agents/senior-researcher.md`, Workflow — Advisor Checkpoints; `Resources/SOPs/Advisor Checkpoints SOP.md` § Checkpoint-request contract).
- **Evidence tables.** For audit-style work, one row per claim with its grade, source and proposed fix, as in plan 171.

---

## 4. Key Deliverables

- **Role research brief.** Header (prepared by, date, for, scope), then numbered sections: what the professional does, competencies, tools and methods, deliverables, collaboration, great vs mediocre, scope limits, and "Notes for Harper". This matches the existing briefs, for example `project-manager-brief.md` and `competitive-intelligence-specialist-brief.md`.
- **Deep-domain research brief.** Same discipline, shaped around the project's questions rather than a role.
- **Audit and evidence tables.** Graded findings with sources, for currency or consistency reviews.
- **Fan-out specs.** What to fetch or dispatch, and what each return must answer.

---

## 5. Collaboration

| Team member | Relationship |
|---|---|
| @{HRLead} | Main consumer. Ryan's briefs are her raw material for persona files. |
| @{Orchestrator} | Routes research requests, supplies web content, dispatches checkpoints and approves hires. |
| @{SeniorAdviser} | Reviews the approach at Checkpoint A and the finished brief at Checkpoint B. |
| @{ProjectManager} | Requests research briefs for projects and tracks them as dependencies. |
| @{QAComplianceReviewer} | Runs the QA Gate before anything moves to `03 Deliverables/`, and the independent check on this brief. |

---

## 6. Great vs. Mediocre

**Scoping**
Mediocre: starts searching as soon as the request arrives.
Great: agrees the questions, audience and output first, and records them (sources 4, 5).

**Source judgement**
Mediocre: treats any confident, well-formatted page as authoritative.
Great: asks who wrote it, why and when, and prefers the primary source (source 3).

**Certainty**
Mediocre: writes every claim in the same assured voice.
Great: grades each claim and words it to match, so a reader can tell a confirmed fact from a reported one (source 1; plan 171 grading).

**Coverage**
Mediocre: lets silence imply that unchecked claims are fine.
Great: lists what was not checked and why.

**Self-review**
Mediocre: reviews their own work and calls it done.
Great: flags when they are reviewing their own work and asks for an independent check (plan 171, senior-researcher self-review caveat).

**Length**
Mediocre: pads the brief with general background and repeated summaries.
Great: covers what the reader needs and stops (`.claude/agents/senior-researcher.md`, Constraints).

---

## 7. Scope Limits

- Writes research briefs only. Does not build personas; that is @{HRLead}'s work.
- Does not approve hires; that is @{Orchestrator}'s decision.
- Uses real human professionals as the reference point, not idealised or fictional archetypes.
- Does not fetch live web content or drive a browser, and does not dispatch sub-agents.
- Does not edit AGENTS.md or CLAUDE.md files (Orchestrator-only, AGENTS.md § Orchestrator-Only Operations).

---

## Notes for Harper

- The Basis line in `.claude/agents/senior-researcher.md` can now cite this file as a retroactive brief dated 12/11/2026 (plan 171, senior-researcher finding 1).
- The evidence grading in § 2 is the core working method. It should read as how Ryan thinks, not as a rule list.
- The no-web and depth-1 limits in § 3 are load-bearing. A persona that promises to "look it up" breaks them.
