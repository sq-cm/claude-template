# /seo-pipeline

You are the Orchestrator. This command runs an autonomous 7-stage SEO audit pipeline against a single URL and produces a branded HTML report.

## Rules

- Never skip a stage. If a sub-agent fails twice, record the failure and continue — do not abort the pipeline.
- Prefix every major action with its stage label, e.g. `[1/7] Parsing URL…`
- The user supplies the URL as the first argument to this command: `$ARGUMENTS`
- All file paths in this command are relative to the vault root unless stated otherwise.
- Do not move any file without explicit user confirmation.
- Never run QA inline — Quinn must be spawned as a sub-agent.
- Never run Advisor checkpoints inline — Odin must be spawned as a sub-agent using `model: claude-opus-4-7`. If Odin is unavailable (timeout, empty response, error), follow `Resources/SOPs/Odin Fallback SOP.md`.
- Quinn's FLAGGED loop is capped at 2 revision cycles. If still FLAGGED after 2 cycles, halt and report to the user.
- Do not read, write, or execute environment secrets directly. Sub-agents that require API keys (e.g. DataForSEO, Google Search Console) will fail-fast with a descriptive error if keys are missing — surface that error and continue with `status: "failed"`.

---

## Step 1 — Parse and validate the URL

`[1/7] Parsing URL…`

1. Extract the URL from `$ARGUMENTS`. Trim whitespace.
2. Validate: must begin with `http://` or `https://`. Must resolve to a single host (no wildcards, no path wildcards). If invalid, halt immediately and print: `Error: /seo-pipeline requires a valid URL (e.g. https://example.com.au). Received: [input]`
3. Derive the slug:
   - Extract the hostname (strip scheme, strip `www.` prefix if present).
   - Replace every `.` with `-`.
   - Append `-` and today's date in `YYYY-MM-DD` format (use current system date).
   - Example: `https://bloom-bakery.com.au` → `bloom-bakery-com-au-2026-05-02`
4. Set project root: `Projects/SEO Audits/[slug]/`
5. Collision check: if `Projects/SEO Audits/[slug]/` already exists, append `-2` (then `-3`, etc.) until the path is free.
6. Create folders:
   ```
   Projects/SEO Audits/[slug]/results/
   Projects/SEO Audits/[slug]/Deliverables/
   ```
7. Write a pipeline log file at `Projects/SEO Audits/[slug]/results/pipeline.log` with:
   ```
   pipeline_start: [ISO timestamp]
   url: [audited url]
   slug: [slug]
   stage: 1/7 — URL parsed and validated
   ```
   Append a new line to this log at the start of each subsequent stage.

Print: `[1/7] Folders created at Projects/SEO Audits/[slug]/`

---

## Step 2 — Spawn 4 parallel SEO agents

`[2/7] Spawning 4 parallel SEO agents…`

Spawn all four agents as simultaneously as possible (use background sub-agents where the environment supports it). Each agent is independent — do not chain them.

**Required JSON output schema** (all agents must produce this structure; field names are fixed):

```json
{
  "status": "ok",
  "agent": "<technical | content | schema | geo-llms>",
  "url": "<audited url>",
  "generated_at": "<ISO 8601 timestamp>",
  "summary": "<2–3 sentence plain English summary of findings>",
  "score": <integer 0–100>,
  "issues": [
    {
      "severity": "<critical | high | medium | low>",
      "title": "<short issue title>",
      "detail": "<what was found>",
      "recommendation": "<what to fix>"
    }
  ],
  "passes": ["<string>", "..."],
  "raw_data": {}
}
```

**Failure JSON** (written on second agent failure):

```json
{
  "status": "failed",
  "agent": "<agent name>",
  "url": "<audited url>",
  "generated_at": "<ISO 8601 timestamp>",
  "error": "<error message>"
}
```

**Retry rule:** If an agent fails on first attempt, clear any partial output file and retry once. If it fails on the second attempt, write the failure JSON and continue — do not halt the pipeline.

---

### Agent A — Technical SEO

Invoke skill: `claude-seo:seo-technical` on the URL.

The agent must audit: crawlability, indexation, canonical tags, redirect chains, Core Web Vitals indicators, robots.txt, sitemap, hreflang (if applicable), HTTPS status, mobile usability signals.

Write output to: `Projects/SEO Audits/[slug]/results/technical.json`

---

### Agent B — Content Quality

Invoke skill: `claude-seo:seo-content` on the URL.

The agent must audit: title tags, meta descriptions, heading hierarchy, keyword relevance, content depth, duplicate content signals, internal linking, readability, E-E-A-T signals.

Write output to: `Projects/SEO Audits/[slug]/results/content.json`

---

### Agent C — Schema and Meta

Invoke skill: `claude-seo:seo-schema` on the URL.

The agent must audit: structured data types present, JSON-LD validity, Open Graph tags, Twitter Card tags, schema coverage gaps, breadcrumb markup, FAQ/How-to schema if applicable.

Write output to: `Projects/SEO Audits/[slug]/results/schema.json`

---

### Agent D — AI Search and llms.txt

Invoke skill: `claude-seo:seo-geo` on the URL.

The agent must audit: presence and validity of `/llms.txt`, AI-friendly content structure, entity clarity, FAQ and definitional content, citation-ready formatting, presence in AI-search-relevant formats.

Write output to: `Projects/SEO Audits/[slug]/results/geo-llms.json`

---

Print: `[2/7] Agent results written to results/`

---

## Step 3 — Validate JSON outputs

`[3/7] Validating agent outputs…`

For each of the four output files:

1. Check the file exists and is valid JSON.
2. Check `status` field is present and is either `"ok"` or `"failed"`.
3. For `status: "ok"` files only:
   - Confirm all required top-level keys are present: `status`, `agent`, `url`, `generated_at`, `summary`, `score`, `issues`, `passes`, `raw_data`.
   - Confirm `score` is an integer between 0 and 100.
   - Confirm `issues` is an array (may be empty).
   - Confirm `summary` is a non-empty string.
   - Flag any null values in `summary`, `score`, or `agent` as validation errors.
4. For `status: "failed"` files: confirm `error` field is present and non-empty.

Print a validation table:

```
Agent         | Status  | Validation
--------------|---------|-----------
technical     | ok      | PASS
content       | ok      | PASS
schema        | failed  | skipped (agent failed)
geo-llms      | ok      | PASS
```

List any specific validation errors found. If a `status: "ok"` file fails validation (e.g. null score, missing required key), overwrite the file on disk with a failure JSON (using `status: "failed"` and an `error` field describing the validation failure) so that all downstream readers see the correct status. Note the downgrade clearly in the validation table and in `pipeline.log`.

Print: `[3/7] Validation complete`

Append stage status to `pipeline.log`.

---

## Step 4 — Checkpoint A (Senior Adviser)

`[4/7] Checkpoint A — consulting Senior Adviser before synthesis…`

Spawn a sub-agent using `model: claude-opus-4-7` with the following prompt:

> You are Odin — Senior Adviser (see `.claude/agents/senior-adviser.md`). Respond in ≤100 words, enumerated steps, no explanations.
>
> Context: An SEO audit pipeline has completed its data-gathering stage. Four specialist sub-agents audited [URL] and wrote JSON outputs. The pipeline is about to synthesise these into an HTML report.
>
> Review the raw JSON data below for: interpretation errors, false positives, coverage gaps, and any finding that contradicts another agent's output.
>
> [Paste full contents of all available results/*.json files here]
>
> Question: What interpretation errors, false positives, or coverage gaps should the synthesizer be aware of before writing the HTML report?

Surface Odin's verdict to the user. If Odin names a specific interpretation error or false positive, pass it as a correction note to the Synthesizer in Step 5. A checkpoint A ruling does not halt the pipeline — it annotates the synthesis brief.

Print: `[4/7] Checkpoint A complete`

Append Odin's verdict to `pipeline.log`.

---

## Step 5 — Synthesize HTML report

`[5/7] Synthesizing HTML report…`

Spawn a sub-agent with the following task:

Read all files in `Projects/SEO Audits/[slug]/results/` (except `pipeline.log`). Apply any correction notes from Checkpoint A. Write a complete, self-contained HTML report to `Projects/SEO Audits/[slug]/results/report.html`.

**Minimum data threshold:** If all four agents have `status: "failed"`, halt synthesis and report to the user: `Error: All four agents failed — no data available to synthesise. Check skill availability and retry.`

**Report specification:**

The report must be a single self-contained HTML file (no external file dependencies beyond the font import below).

### Layout and brand

```css
/* Typography */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400&display=swap');
/* Use Aeonik if available via @font-face; fallback: Inter, Helvetica Neue, sans-serif */
font-family: 'Aeonik', 'Inter', 'Helvetica Neue', sans-serif;
font-weight: 400;

/* Palette */
--color-primary: #000000;
--color-background: #ffffff;
--color-text: #070707;
--color-border: #e5e7eb;
--color-accent: #0d9488;   /* teal — score badges, section header accents */

/* Type scale */
h1: 36px;  h2: 24px;  h3: 20px;  h4: 18px;
body: 16px / 24px line-height;

/* Components */
/* Buttons: pill-shaped, border-radius 100px, transparent/outline style */
/* Cards: white, 1px #e5e7eb border, border-radius 8px, no box-shadow, comfortable padding */
/* No gradients. No decorative shadows. No rounded decorative elements beyond pill buttons. */
/* Generous whitespace throughout. Flat design. */
```

### Report structure

**Header:**
- Studio Quarantine wordmark (text, not image — use `<h1>` or styled `<span>`)
- Audited URL (linked)
- Date generated (ISO date)

**Section cards (one per agent, in this order):**
1. Technical SEO
2. Content Quality
3. Schema & Meta
4. AI Search & llms.txt

Each card contains:
- Agent name as card heading
- Score badge (teal `--color-accent` background, white text, pill shape) — omit if agent failed
- 2–3 sentence summary (from `summary` field)
- Issues list sorted by severity: critical → high → medium → low. Each issue shows title, detail, and recommendation.
- Passes list (bullet points)
- If agent status is `"failed"`: display a notice inside the card — `⚠ Data unavailable — agent failed` — in place of score, summary, issues, and passes. Do not omit the card.

**Correction notes section** (if Checkpoint A returned specific corrections): display below the four agent cards as a "Reviewer Notes" section.

**Footer:**
- Text: "Generated by Studio Quarantine AI Team"

Print: `[5/7] HTML report written to results/report.html`

Append stage status to `pipeline.log`.

---

## Step 6 — QA Gate

`[6/7] QA Gate — spawning Quinn…`

Spawn Quinn (QA Compliance Reviewer) as a sub-agent using `.claude/agents/qa-compliance-reviewer.md`. Quinn must not be run inline.

Direct Quinn to review `Projects/SEO Audits/[slug]/results/report.html` against the following checklist:

- HTML is valid and self-contained (no broken references)
- All four agent cards are present, even for failed agents
- Failed agent cards show the warning notice
- Score badges are present for all `status: "ok"` agents
- Issues are sorted correctly: critical → high → medium → low
- No null, undefined, or placeholder text (e.g. `[AGENT NAME]`, `Lorem ipsum`)
- Brand spec is applied: correct palette variables, no shadows, no gradients, pill buttons, 8px card border-radius
- Header contains: Studio Quarantine wordmark, audited URL, date generated
- Footer contains: "Generated by Studio Quarantine AI Team"
- Correction notes from Checkpoint A are present in the report (if any were issued)
- No AI-writing signals (hedging language, filler phrases, prompt artefacts)
- No factual claims that contradict the source JSON data

**Quinn's verdict handling:**

- **PASS** — proceed to Step 6a (Humaniser).
- **FLAGGED** — return Quinn's specific issues to the Synthesizer sub-agent for targeted revision. Re-run Quinn on the revised file. This loop is capped at 2 cycles. If still FLAGGED after 2 revision cycles, halt and report to the user with Quinn's outstanding issues — do not proceed to delivery.
- **BLOCKED** — halt immediately. Print Quinn's blocking issues. Do not proceed. Inform the user that manual intervention is required before the report can be delivered.

Print: `[6/7] QA Gate complete — verdict: [PASS | PASS (after revision) | BLOCKED]`

Append Quinn's verdict to `pipeline.log`.

### Step 6a — Humaniser

After Quinn's PASS and before Checkpoint B:

The `/humaniser` command runs in the main session thread — do not attempt to invoke it from inside a sub-agent task. Extract the text content nodes from `results/report.html` (summary paragraphs, issue details, recommendations, passes lists, and correction notes) and pass them directly to `/humaniser` from the main thread. Do not pass structural HTML, JSON-LD blocks, script content, or data attributes — text content only.

Apply the humanised text back into `results/report.html` using targeted edits. Do not alter any structural HTML, classes, or data attributes.

Print: `[6a] Humaniser applied to report text sections`

---

## Step 7 — Checkpoint B and delivery

`[7/7] Checkpoint B — consulting Senior Adviser on final report…`

Spawn a sub-agent using `model: claude-opus-4-7` with the following prompt:

> You are Odin — Senior Adviser (see `.claude/agents/senior-adviser.md`). Respond in ≤100 words, enumerated steps, no explanations.
>
> Context: An SEO audit pipeline has produced a final HTML report for [URL]. The report has passed QA review and humanisation.
>
> Review the report for: strategic coherence of recommendations (are they actionable, non-contradictory, and correctly prioritised?), coverage gaps that QA would not have caught, and any finding that should be escalated before delivery.
>
> [Paste the full text content of results/report.html here — omit raw HTML tags, keep readable content]
>
> Question: Are the recommendations actionable, non-contradictory, and prioritised correctly? What, if anything, should be addressed before this report is delivered?

Surface Odin's verdict to the user.

**Checkpoint B handling:** Odin's verdict is advisory — it does not automatically halt delivery. If Odin flags a specific actionable issue (not a stylistic preference), print it prominently and ask the user: "Odin has flagged an issue — address it before delivery? [y/n]". On y: return the specific issue to the Synthesizer sub-agent, re-run Quinn, re-run Humaniser, then re-run Checkpoint B (one additional cycle only). On n: proceed to delivery with the issue logged.

Append Odin's verdict and user decision to `pipeline.log`.

---

Print the report path:

```
Report ready: Projects/SEO Audits/[slug]/results/report.html
```

Ask the user:

> Move report to Deliverables? Confirm with **y** to move `results/report.html` to `Deliverables/report.html`, or **n** to leave it in results for further review.

On **y**: move `Projects/SEO Audits/[slug]/results/report.html` to `Projects/SEO Audits/[slug]/Deliverables/report.html`. Confirm: `Report moved to Projects/SEO Audits/[slug]/Deliverables/report.html`

On **n**: print: `Report left in results/. Run /seo-pipeline again or move manually when ready.`

Append final status to `pipeline.log`:

```
pipeline_end: [ISO timestamp]
final_status: [delivered | held in results]
deliverable_path: [path or none]
```

Print: `[7/7] Pipeline complete.`

---

## Failure reference

| Failure mode | Behaviour |
|---|---|
| Invalid or malformed URL | Halt at Step 1 with error message |
| Agent fails twice | Write failure JSON, continue pipeline |
| All 4 agents fail | Halt at Step 5 with error message |
| JSON validation fails for `status:ok` file | Overwrite file with failure JSON on disk, continue |
| Quinn FLAGGED after 2 revision cycles | Halt, report outstanding issues to user |
| Quinn BLOCKED | Halt immediately, report blocking issues |
| Missing env/API key in sub-agent | Sub-agent surfaces error, pipeline records failure JSON and continues |
| Project folder already exists | Append `-2` suffix to slug before creating |
