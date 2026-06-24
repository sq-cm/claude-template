---
name: shotlist-html-companion
description: |
  Render an interactive HTML companion from an approved shotlist or Seedance prompt set.
  Produces a single self-contained editable HTML file alongside the canonical MD/shotlist.
  Use when a user or collaborator requests: "shotlist HTML", "editable shotlist",
  "make the shotlist interactive", "HTML version of the shotlist", or "interactive prompts".
  Scope: shotlist and prompt-set deliverables (Seedance commercial or narrative) only —
  distinct from the six html-deliverable types (audit reports, status reports, etc.).
---

# Shotlist HTML Companion

## Scope and distinction

This skill turns an **approved shotlist or Seedance prompt set** into a single self-contained editable HTML file. It is **not** a substitute for the `html-deliverable` skill, which covers audit reports, status reports, implementation plans, comparisons, research explainers, and incident post-mortems. If the deliverable is one of those six types, route to `html-deliverable` instead.

Shotlist HTML companions are in scope for:
- Seedance 2.0 commercial shotlists
- Seedance 2.0 narrative / short-film shotlists
- Any structured prompt set where the operator needs per-scene checkboxes, copy-ready prompts, and a shared style prefix

---

## Architecture constraint — single-pass, no fan-out

This skill runs **inline**. It does **not** dispatch sub-agents. Consistent with the depth-1 sub-agent architecture constraint in CLAUDE.md, the shotlist HTML companion is produced by the generating persona in a single pass. No fan-out, no orchestration layer.

---

## Canonical source and path convention

The MD shotlist (or structured prompt document) is the **canonical source of truth**. The HTML file is a render of it — it is never edited directly.

Save the HTML file next to the canonical MD in the project's working folder:

```
Projects/<project-name>/02 Working/
  <shotlist-name>.md      ← canonical source
  <shotlist-name>.html    ← render (this file)
```

When handing off, announce both paths:

> "MD shotlist at [path], interactive HTML companion at [path]."

Never save to `/mnt/user-data/outputs/` or any environment-specific path. The path convention above is the standard.

---

## Routing through html-deliverable

This skill follows the same sibling-pair, footer, drift, and QA conventions as `html-deliverable`. The differences are in the HTML structure (shotlist-specific components) and the triggering deliverable type — not in the governance layer.

### Post-MD nudge

After the MD shotlist is QA-passed by `@{QAComplianceReviewer}`, deliver this line exactly:

> "Want this as an interactive HTML companion? Say the word."

Do not offer the HTML before QA sign-off on the MD.

### QA flow

Steps must run in order:

1. MD shotlist produced by the generating persona (e.g. `@{SeedanceDirector}`).
2. Humaniser pass on MD.
3. `@{QAComplianceReviewer}` QA on MD — must PASS before HTML is rendered.
4. HTML rendered from approved MD using the template below.
5. `@{QAComplianceReviewer}` second pass on HTML (links resolve, no JS console errors, prints cleanly, localStorage keys stable, copy buttons functional, footer present and correct).

HTML is not shipped until both QA passes clear.

### Sibling-pair rule

MD and HTML ship as a matched pair in the same folder, same stem:

```
<shotlist-name>.md    ← canonical
<shotlist-name>.html  ← render
```

MD is canonical. When MD changes, rebuild the HTML from the updated MD — do not edit the HTML directly.

---

## Footer spec (mandatory — mirrors html-deliverable)

Every rendered HTML file carries a `<footer class="footer-meta" role="contentinfo">` with three elements, each in its own `<span class="footer-meta__item">`, in this exact label format:

1. **Render timestamp** — `Rendered: <ISO 8601, local timezone>`. Example: `Rendered: 2026-05-23T15:32:00+10:00`.
2. **Content hash** — `Source hash: <8 chars>`. First 8 characters of the SHA-1 hash of the source MD file. Normalise to LF line endings and strip trailing whitespace before hashing — prevents false drift on Windows checkouts.
3. **Studio attribution** — `Produced by {{Studio}} · <date>`.

Label punctuation is canonical — `Rendered:` and `Source hash:` (with colon and single space). QA blocks footers that omit either label or use a different prefix.

The hash enables drift detection: if the hash in the footer does not match a fresh hash of the current MD, the HTML is stale and must be rebuilt.

---

## Drift policy

### Rebuild HTML when:

- A scene is added, removed, or reordered.
- A prompt is rewritten (any CUT, Characters, Scene block, or Style Prefix change).
- Scene numbers change.
- The style prefix is updated.

### Skip rebuild when:

- Typo fixes only, with no semantic shift.
- Humaniser tweaks that do not alter prompt content.

The generating persona judges substantive vs cosmetic. When ambiguous, rebuild.

---

## Build constraints

- Vanilla HTML, single file only.
- Inline `<style>` and `<script>` — no `<link>` to external stylesheets, no external script tags.
- No CDN. No network requests. No framework. No package dependencies.
- Archive-safe: must open and render correctly with no internet connection.
- Charts or diagrams: inline SVG only (rarely needed in shotlists; include if the brief calls for a shot map).

---

## HTML structure

### CSS variables and visual style

The shotlist companion uses a dark directing-room palette — easy on the eyes for long sessions, distinct from the studio-shell light-mode defaults used by `html-deliverable`. Override the shell defaults with the variables below.

```css
:root {
  --bg: #0e0e10;
  --panel: #17171a;
  --panel-2: #1d1d21;
  --border: #2a2a30;
  --text: #e8e8ea;
  --text-dim: #9a9aa2;
  --accent: #d4a259;
  --done: #4ade80;
}
```

### Required interactive features

**Per-scene checkboxes with localStorage persistence**

Each scene has one checkbox, regardless of how many prompts (1a, 1b, 1c) it contains. The operator ticks a scene when all its prompts are complete.

localStorage key per scene: `shotlist-scene-{sceneNumber}-done` (value `"1"` or `"0"`).

Scene numbers are the stability anchor — never renumber existing scenes during a revision. New scenes append at the end (or insert with a letter suffix, e.g. `4b`) to preserve existing localStorage keys and operator progress.

**Copy button per prompt**

Each individual prompt block (1a, 2a, 2b, etc.) carries its own Copy button. Clicking it copies the full prompt text to the clipboard — Style Prefix prepended verbatim, followed by Characters, Scene, and CUT blocks. The operator pastes directly into Seedance; no reassembly needed.

Button states: default → "Copy"; on success → "Copied" (green, 1500 ms) → revert.

**Collapsible global Style Prefix block**

The Style Prefix appears once at the top of the document in a `<details>` / `<summary>` disclosure block. Collapsed by default after first load (the operator knows it is there; they do not need to read it every time). The same prefix text is also prepended verbatim to every prompt's copy-block content — invisible in the UI but present in the copied text.

**Individually addressable prompts (1a / 1b / 2a naming)**

Every prompt block carries a unique label (`Prompt 1a`, `Prompt 2b`, etc.) and the HTML `id` attribute `prompt-{sceneNumber}{letter}` (e.g. `id="prompt-1a"`). This allows a single prompt to be revised and the HTML rebuilt without disturbing scene numbering, localStorage keys, or surrounding prompts.

---

## HTML template

Use this skeleton. Fill `{{PROJECT_TITLE}}`, `{{STYLE_PREFIX_TEXT}}`, `{{SCENES_HTML}}`, `{{RENDER_TIMESTAMP}}`, `{{SOURCE_HASH}}`, and `{{STUDIO_NAME}}`.

```html
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{PROJECT_TITLE}} — Shotlist</title>
<noscript><style>.theme-toggle{display:none}</style></noscript>
<style>
  :root {
    --bg: #0e0e10;
    --panel: #17171a;
    --panel-2: #1d1d21;
    --border: #2a2a30;
    --text: #e8e8ea;
    --text-dim: #9a9aa2;
    --accent: #d4a259;
    --done: #4ade80;
    --container: 980px;
    --space-1: 4px;
    --space-2: 8px;
    --space-3: 14px;
    --space-4: 20px;
    --space-5: 32px;
  }
  [data-theme="light"] {
    --bg: #f5f5f0;
    --panel: #ffffff;
    --panel-2: #f0f0eb;
    --border: #d8d8d0;
    --text: #1a1a1a;
    --text-dim: #6b6b6b;
    --accent: #b07d2a;
    --done: #1a7a3a;
  }
  * { box-sizing: border-box; }
  body {
    margin: 0;
    background: var(--bg);
    color: var(--text);
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", system-ui, sans-serif;
    line-height: 1.5;
    padding: var(--space-5) 24px 80px;
  }
  @media (max-width: 680px) {
    body { padding: 20px 16px 60px; }
  }
  .container { max-width: var(--container); margin: 0 auto; }
  h1 {
    font-size: 28px; font-weight: 600; margin: 0 0 var(--space-1);
    letter-spacing: -0.02em;
  }
  .subtitle { color: var(--text-dim); font-size: 14px; margin-bottom: var(--space-5); }
  .howto {
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: var(--space-3) 18px;
    font-size: 13px;
    color: var(--text-dim);
    margin-bottom: 24px;
  }
  /* Style Prefix */
  details.style-prefix {
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: var(--space-3) 18px;
    margin-bottom: var(--space-5);
  }
  details.style-prefix summary {
    cursor: pointer; font-weight: 600;
    color: var(--accent); user-select: none;
  }
  details.style-prefix pre {
    margin: var(--space-3) 0 0; padding: var(--space-3);
    background: var(--panel-2);
    border-radius: 6px;
    font-family: "SF Mono", Menlo, Consolas, monospace;
    font-size: 12.5px;
    white-space: pre-wrap;
    color: var(--text);
  }
  /* Scene blocks */
  .scene {
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: var(--space-4) 22px;
    margin-bottom: 18px;
  }
  .scene-header {
    display: flex; align-items: flex-start; gap: 12px;
    margin-bottom: var(--space-3);
  }
  .scene-header input[type="checkbox"] {
    width: 20px; height: 20px; margin-top: 2px;
    accent-color: var(--done); cursor: pointer;
    flex-shrink: 0;
  }
  .scene-num {
    font-size: 18px; font-weight: 700;
    color: var(--accent); min-width: 56px;
  }
  .scene-desc {
    font-size: 15px; color: var(--text);
    flex: 1;
  }
  .scene.done .scene-desc { text-decoration: line-through; color: var(--text-dim); }
  /* Prompt blocks */
  .prompt-block {
    background: var(--panel-2);
    border: 1px solid var(--border);
    border-radius: 6px;
    margin-top: 12px;
    overflow: hidden;
  }
  .prompt-label {
    display: flex; justify-content: space-between; align-items: center;
    padding: var(--space-2) var(--space-3);
    background: rgba(128,128,128,0.04);
    border-bottom: 1px solid var(--border);
    font-size: 12px; color: var(--text-dim);
    text-transform: uppercase; letter-spacing: 0.05em;
  }
  .copy-btn {
    background: transparent; color: var(--accent);
    border: 1px solid var(--border); border-radius: 4px;
    padding: 4px 10px; font-size: 11px; cursor: pointer;
    text-transform: uppercase; letter-spacing: 0.05em;
    font-family: inherit;
  }
  .copy-btn:hover { border-color: var(--accent); }
  .copy-btn:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
  .copy-btn.copied { color: var(--done); border-color: var(--done); }
  pre.prompt {
    margin: 0; padding: var(--space-3) 16px;
    font-family: "SF Mono", Menlo, Consolas, monospace;
    font-size: 12.5px;
    white-space: pre-wrap;
    color: var(--text);
  }
  /* Theme toggle */
  .theme-toggle {
    position: fixed; top: 12px; right: 12px;
    width: 36px; height: 36px;
    background: var(--panel); border: 1px solid var(--border);
    border-radius: 50%; cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    padding: 0;
  }
  .theme-toggle:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }
  .theme-toggle svg { width: 18px; height: 18px; stroke: var(--text-dim); fill: none; stroke-width: 1.5; }
  /* Footer */
  .footer-meta {
    margin-top: 48px;
    padding-top: 16px;
    border-top: 1px solid var(--border);
    font-size: 11px;
    color: var(--text-dim);
    display: flex; flex-wrap: wrap; gap: 16px;
  }
  /* Print */
  @media print {
    .theme-toggle { display: none; }
    .copy-btn { display: none; }
    body { background: #fff; color: #000; padding: 0; }
    .scene { border: 1px solid #ccc; }
  }
</style>
</head>
<body>
<div class="container">
  <h1>{{PROJECT_TITLE}}</h1>
  <div class="subtitle">Director's Shotlist · Seedance 2.0</div>

  <div class="howto">
    Tick scenes as you finish them — progress saves automatically in your browser.
    Click Copy on any prompt to grab the full text (Style Prefix + Characters + Scene + Cuts) ready for Seedance.
    To revise, tell the producing persona what to change — the HTML is rebuilt from the source MD, not edited directly.
  </div>

  <details class="style-prefix">
    <summary>Global Style Prefix (prepended to every prompt on copy)</summary>
    <pre>{{STYLE_PREFIX_TEXT}}</pre>
  </details>

  {{SCENES_HTML}}

  <footer class="footer-meta" role="contentinfo">
    <span class="footer-meta__item">Rendered: {{RENDER_TIMESTAMP}}</span>
    <span class="footer-meta__item">Source hash: {{SOURCE_HASH}}</span>
    <span class="footer-meta__item">Produced by {{STUDIO_NAME}} · {{DATE}}</span>
  </footer>
</div>

<button class="theme-toggle" id="theme-toggle" aria-label="Toggle theme">
  <svg id="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
  <svg id="icon-moon" viewBox="0 0 24 24" style="display:none"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
</button>

<script>
  (function () {
    // Theme toggle
    var THEME_KEY = 'shotlist-html-theme';
    var html = document.documentElement;
    var btn  = document.getElementById('theme-toggle');
    var sun  = document.getElementById('icon-sun');
    var moon = document.getElementById('icon-moon');

    function applyTheme(theme) {
      html.setAttribute('data-theme', theme);
      if (theme === 'dark') {
        sun.style.display  = '';
        moon.style.display = 'none';
      } else {
        sun.style.display  = 'none';
        moon.style.display = '';
      }
    }

    var stored = localStorage.getItem(THEME_KEY);
    if (stored) {
      applyTheme(stored);
    }
    // Default is dark (set on <html>); no OS preference override needed.

    btn.addEventListener('click', function () {
      var current = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      applyTheme(current);
      localStorage.setItem(THEME_KEY, current);
    });

    // Checkbox persistence
    document.querySelectorAll('.scene input[type="checkbox"]').forEach(function (cb) {
      var key = 'shotlist-scene-' + cb.dataset.scene + '-done';
      if (localStorage.getItem(key) === '1') {
        cb.checked = true;
        cb.closest('.scene').classList.add('done');
      }
      cb.addEventListener('change', function () {
        localStorage.setItem(key, cb.checked ? '1' : '0');
        cb.closest('.scene').classList.toggle('done', cb.checked);
      });
    });

    // Copy buttons
    document.querySelectorAll('.copy-btn').forEach(function (btn) {
      btn.addEventListener('click', function () {
        var pre = btn.closest('.prompt-block').querySelector('pre.prompt');
        navigator.clipboard.writeText(pre.textContent).then(function () {
          btn.classList.add('copied');
          var original = btn.textContent;
          btn.textContent = 'Copied';
          setTimeout(function () {
            btn.classList.remove('copied');
            btn.textContent = original;
          }, 1500);
        });
      });
    });
  }());
</script>
</body>
</html>
```

---

## Scene block pattern

Each scene block in `{{SCENES_HTML}}` follows this structure. One checkbox per scene — even when the scene has multiple prompts (3a, 3b, 3c). The `data-scene` attribute uses the bare scene number (integer as string) as the localStorage key anchor.

Each prompt block carries:
- A unique label (`Prompt 3a · 15s`)
- An `id` attribute (`id="prompt-3a"`) for individual addressability
- A Copy button
- A `<pre class="prompt">` containing the full prompt text with Style Prefix prepended verbatim

```html
<div class="scene">
  <div class="scene-header">
    <input type="checkbox" data-scene="3">
    <div class="scene-num">3.</div>
    <div class="scene-desc">Anna confronts Marco in the kitchen — first crack in their relationship.</div>
  </div>

  <div class="prompt-block" id="prompt-3a">
    <div class="prompt-label">
      <span>Prompt 3a · 15s</span>
      <button class="copy-btn">Copy</button>
    </div>
    <pre class="prompt">[FULL PROMPT TEXT — Style Prefix verbatim, then Characters, Scene, CUT 1, CUT 2, CUT 3]</pre>
  </div>

  <div class="prompt-block" id="prompt-3b">
    <div class="prompt-label">
      <span>Prompt 3b · 15s</span>
      <button class="copy-btn">Copy</button>
    </div>
    <pre class="prompt">[FULL PROMPT TEXT for the second 15-second chunk of scene 3]</pre>
  </div>
</div>
```

**Scene number stability rule:** never renumber existing scenes during a revision. New scenes append (or insert with a letter suffix, e.g. `4b`) so localStorage keys and operator progress are preserved. The `id` on each `.prompt-block` (`id="prompt-3a"`) allows a single prompt to be revised without disturbing the rest of the document.

---

## Revision workflow

When the operator requests changes to the shotlist:

1. Revise the canonical MD first.
2. Confirm the revision is substantive (see drift policy above).
3. Rebuild the HTML from the updated MD using the template.
4. Preserve existing scene numbers and `data-scene` values — only new or removed scenes affect the numbering.
5. Update the footer: new render timestamp, new source hash.
6. Do not edit the HTML directly — always rebuild from MD.

---

## Checklist for the rendering persona

Before handing off the HTML to `@{QAComplianceReviewer}`:

- [ ] Single self-contained file — no external dependencies
- [ ] Style Prefix block present, collapsible, collapsed by default
- [ ] Each scene has exactly one checkbox with correct `data-scene` value
- [ ] Each prompt block has a unique `id` (`prompt-1a`, `prompt-2b`, etc.)
- [ ] Copy button on every prompt block; full prompt text (with Style Prefix) in the `<pre>`
- [ ] Footer present with `Rendered:`, `Source hash:`, and `Produced by` fields
- [ ] Source hash is first 8 chars of SHA-1 of the normalised MD (LF endings, no trailing whitespace)
- [ ] Theme toggle present, keyboard-focusable, `aria-label="Toggle theme"`
- [ ] No hardcoded `/mnt/user-data/outputs/` or other environment-specific paths
- [ ] HTML saved next to the canonical MD (not in `03 Deliverables/` — that move requires QA Gate)
