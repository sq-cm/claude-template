# SOP — Output Locale

**Purpose:** Define which English variant every piece of written prose uses, how a project declares one, and what each declarable variant actually means in practice.
**Audience:** The Orchestrator (names the locale in every dispatch), all working personas (write to it), @{QAComplianceReviewer} (verifies it at the Gate).
**Status:** Active. Owned by the Orchestrator.

---

## The two-tier rule

Locale is decided by **who the prose is for**, not by who wrote it.

**Tier 1 — vault-internal prose is Australian English, always.** No declaration, no override, no exceptions. This covers SOPs, skills, persona files, folder-tier `CLAUDE.md` files, plans, audits, status and research reports, session and memory notes, template field text, and the prose inside a project's own `CONTEXT.md` and `HISTORY.md`. A project may ship deliverables in `en-US`; its `CONTEXT.md` is still written in Australian English, because the file is read by the team, not the client.

**Tier 2 — deliverable and project prose follows the declared locale.** Anything client-facing or destined for `03 Deliverables/` — copy, articles, emails, ad and landing-page text, decks, scripts, UI microcopy, HTML companions — is written in the locale the project declares. Absent a declaration, the locale is `en-AU`.

The two tiers can differ inside one project and that is the normal case, not a conflict.

## Declaring a locale

- **Where.** A `locale:` field in the project's `CONTEXT.md` (see `Projects/Template/CONTEXT.md` for placement). One line, one value.
- **What.** A BCP-47 language tag — `en-AU`, `en-US`, `en-GB`, `en-CA`, `en-NZ`, `en-IE`. Region subtag required; a bare `en` is not a declaration and resolves to the default.
- **Default.** No `locale:` field, or an empty one, means `en-AU`. Absence is a valid state — most projects never declare.
- **Per-deliverable override.** A deliverable's brief may name a different locale for that artefact alone. The brief beats the project declaration; the project declaration beats the default. The override applies to the one deliverable, never to the project.
- **The Orchestrator names the target locale in every dispatch brief — QA dispatches included.** Personas never look the locale up themselves and never infer it from the request. A dispatch that omits the locale is treated as `en-AU`; a persona that spots an omission on client-facing work flags it back rather than guessing.

## Preset conventions

Six presets. Each is a house pick, not a survey — where real usage is split, the SOP names the variant to write so that output is deterministic.

### en-AU — Australian English (default)

| Convention | Rule |
|---|---|
| Spelling | `-ise` (organise, realise) · `-our` (colour, honour, labour) · `-re` (centre, metre, theatre) · doubled consonant (travelled, cancelled, modelling) · `-yse` (analyse) · defence, offence |
| Noun/verb splits | licence (n.) / license (v.) · practice (n.) / practise (v.) · advice (n.) / advise (v.) |
| Vocabulary | mobile (phone) · footpath · ute · boot (of a car) · petrol · rubbish bin · holiday · autumn · biscuit · jumper · lift · capsicum · postcode · CV |
| Dates | DD/MM/YYYY numeric; 1 September 2026 in full |
| Punctuation | Single quotation marks for quoted material (AGSM); punctuation inside the quotes only when it belongs to the quoted text · no serial comma unless it removes ambiguity · no full stop after contractions (Mr, Dr, Ltd) |
| Units | Metric throughout — km, kg, °C, litres · A$ or AUD for currency |
| Watch-outs | **program**, not programme, in every sense · `-ise` never `-ize` · enquiry and inquiry both live; pick one per document |

### en-GB — British English

| Convention | Rule |
|---|---|
| Spelling | `-ise` (house pick; Oxford `-ize` is a valid British variant but do not mix) · `-our` · `-re` · doubled consonant (travelled, labelled) · `-yse` (analyse) · defence, offence |
| Noun/verb splits | licence (n.) / license (v.) · practice (n.) / practise (v.) |
| Vocabulary | mobile (phone) · pavement · lorry · lift · flat · holiday · autumn · biscuit · jumper · boot · petrol · postcode · CV · maths · aluminium · aeroplane |
| Dates | DD/MM/YYYY numeric; 1 September 2026 in full |
| Punctuation | Single quotation marks are the book-publishing norm and the house pick; logical placement — punctuation outside the closing quote unless part of the quotation · no serial comma by default · no full stop after contractions (Mr, Dr) |
| Units | Metric is official, but everyday usage keeps imperial survivals — road distances and speeds in miles, draught beer in pints, body weight in stones and pounds. Match the register: technical copy metric, consumer copy as a British reader would say it · £ or GBP |
| Watch-outs | **programme** for a schedule, broadcast or scheme; **program** only for software · learnt/spelt/burnt acceptable — be consistent |

### en-US — American English

| Convention | Rule |
|---|---|
| Spelling | `-ize` (organize, realize) · `-or` (color, honor, labor) · `-er` (center, meter, theater) · single consonant (traveled, canceled, modeling) · `-yze` (analyze) · defense, offense · catalog, gray, jewelry |
| Noun/verb splits | None — license and practice serve as both noun and verb |
| Vocabulary | cell phone · sidewalk · truck · elevator · apartment · vacation · fall · cookie · sweater · trunk · gas · ZIP code · résumé · math · aluminum · airplane |
| Dates | **MM/DD/YYYY** numeric; September 1, 2026 in full — comma after the day |
| Punctuation | Double quotation marks primary, single for nesting · commas and periods go **inside** the closing quotation mark regardless of logic · serial comma widely used (Chicago); AP omits it — pick per house style and hold it · full stop after abbreviations (Mr., Dr., Inc.) |
| Units | US customary — miles, pounds, °F, fluid ounces, feet. Metric only in scientific or technical contexts · US$ or USD |
| Watch-outs | The date format is the highest-cost error in the set — `03/09/2026` reads as 3 September to an AU reader and 9 March to a US one. Write dates in full wherever the format is not fixed by a form field |

### en-CA — Canadian English (hybrid)

| Convention | Rule |
|---|---|
| Spelling | British `-our` (colour, honour, favour) **with** American `-ize`/`-yze` (organize, analyze) · `-re` (centre, metre, theatre) · doubled consonant (travelled) · defence · American **tire**, **curb**, **aluminum**; British **cheque** for banking |
| Noun/verb splits | licence (n.) / license (v.) · practice (n.) / practise (v.) — British split retained |
| Vocabulary | cell phone · sidewalk · apartment · elevator · gas · vacation · **postal code** (not ZIP, not postcode) · washroom · grade 5 (not year 5) · fall and autumn both current |
| Dates | Genuinely ambiguous in Canada — DD/MM, MM/DD and YYYY-MM-DD all circulate. **House pick: write dates in full (1 September 2026); use YYYY-MM-DD when a numeric format is required.** Never write a bare DD/MM or MM/DD date in Canadian deliverables |
| Punctuation | Double quotation marks; commas and periods inside the closing quote (Canadian Press follows American placement) · no serial comma (CP) · full stop after abbreviations |
| Units | Metric is official — km, °C, kg, litres — with imperial survivals in everyday speech: height in feet and inches, body weight in pounds, oven temperatures in °F, floor area in square feet · C$ or CAD |
| Watch-outs | The hybrid is the trap. `colour` + `organize` in the same sentence is correct Canadian, not an error — do not 'fix' one to match the other. French-language requirements are a separate matter and out of scope here (see Non-English codes) |

### en-NZ — New Zealand English

| Convention | Rule |
|---|---|
| Spelling | As en-AU — `-ise`, `-our`, `-re`, doubled consonant, `-yse`, defence · **fiord** (not fjord) · **programme** is retained for a schedule or scheme more often than in AU; program for software |
| Noun/verb splits | licence (n.) / license (v.) · practice (n.) / practise (v.) |
| Vocabulary | jandals (thongs) · togs · chilly bin (esky) · dairy (corner shop) · bach (holiday home) · tramping (bushwalking) · kūmara · mobile · footpath · ute · boot · petrol · postcode |
| Dates | DD/MM/YYYY numeric; 1 September 2026 in full |
| Punctuation | As en-AU — single quotation marks, logical placement, no serial comma by default, no full stop after contractions |
| Units | Metric throughout · NZ$ or NZD |
| Watch-outs | **Macrons on te reo Māori words are not optional** — Māori, kūmara, Kāpiti, Whanganui, Aotearoa. A missing macron changes the word and reads as carelessness. Copy proper nouns from an authoritative source rather than typing them · Aotearoa New Zealand is standard in much public-sector and brand copy; confirm in the brief |

### en-IE — Irish English

| Convention | Rule |
|---|---|
| Spelling | As en-GB — `-ise`, `-our`, `-re`, doubled consonant, `-yse`, defence, programme |
| Noun/verb splits | licence (n.) / license (v.) · practice (n.) / practise (v.) |
| Vocabulary | footpath (not pavement) · press (cupboard) · jumper · lift · boot · petrol · **Eircode** (postal code) · Garda / Gardaí (police) · Taoiseach · Dáil · Leaving Certificate · TD (member of parliament) |
| Dates | DD/MM/YYYY numeric; 1 September 2026 in full |
| Punctuation | Follows en-GB practice; quotation-mark style varies by publisher, so pick one per document and hold it · logical placement · no serial comma by default |
| Units | Fully metric, including roads — km and km/h, unlike Great Britain · **€ / EUR**, not sterling |
| Watch-outs | Currency, road units and Eircode are the real differentiators from en-GB — a British-localised piece dropped into an Irish deliverable usually fails on those three before it fails on spelling · fadas on Irish-language proper nouns must be correct (Éire, Dáil Éireann, Seán); Taoiseach carries none |

## Other English variants

Any other English tag — `en-ZA`, `en-IN`, `en-SG` and the rest — is declarable. The team writes best-effort against that variant: spelling and date conventions applied as far as they are reliably known, vocabulary left neutral where it is not. Where a convention is uncertain, the persona notes the ambiguity in the deliverable handoff rather than inventing a rule. @{QAComplianceReviewer} checks the declared variant to the same standard and flags what it cannot verify.

## Non-English codes

Non-English BCP-47 codes are **out of scope**. A `locale: fr-FR` declaration is flagged at intake and routed back — the team does not translate, and does not produce prose in a language it cannot review. This is a hard stop, not a best-effort case. If a client needs translated output, that is a separate scope conversation with the user before any work starts.

## Rewriting existing text

**Preserve the document's existing locale.** When editing, extending or correcting a document, match what is already on the page — even where it differs from the declared locale or from the writer's own habit. An inherited `en-US` document stays `en-US` under a patch.

**Conversion is an explicit task, never a side effect.** Changing a document's locale happens only when the brief says so, as its own piece of work with its own review. A persona that believes a document is in the wrong locale flags it; it does not fix it in passing.

### The prose-only carve-out

Locale rules apply to prose and nothing else:

> **Prose only.** Never alter code, identifiers, file paths, API/CSS keywords (`color`, `center`), package names, proper nouns, or quotations.

Quotations are locale-immune in both directions: a quoted American source keeps its American spelling inside an `en-AU` deliverable.

## QA severity

@{QAComplianceReviewer} verifies locale at the QA Gate against the locale named in the dispatch brief.

| Finding | Verdict |
|---|---|
| Prose does not match the declared locale | **FLAG** — returned for revision, does not stop the file |
| Locale error inside a compliance-sensitive claim — regulated categories (financial services, health, consumer guarantees), legal terms, pricing, dates in contractual or offer text | **BLOCK** |

The block case is narrow and deliberate: `03/09/2026` in an offer-expiry line is a different class of problem from `color` in a body paragraph.

## HTML deliverables

An HTML companion sets its `lang` attribute to the declared locale — `<html lang="en-US">`, `<html lang="en-AU">`. The attribute matches the prose in the document; a mismatch between `lang` and the declared locale is a QA flag. The `lang` value is markup, not prose, so it is never 'corrected' by a locale pass — it is set from the declaration.

## Editor spell-check (cSpell)

The vault's editor spell-check is configured vault-wide as `"cSpell.language": "en,en-GB"` in `.vscode/settings.json`, using British English as the closest available proxy for Australian English. It is **advisory only**:

- Squiggles are AU/GB-biased, so correct `en-US`, `en-CA` and other non-British deliverable prose will show as misspelt. That is expected — do not 'fix' it.
- The setting is vault-wide and is not switched per project. Nothing about a `locale:` declaration changes it.
- **The QA Gate is the real check.** A clean editor is not a locale verdict, and a noisy one is not a defect.

## Vendored-US skill carve-outs

Two skills deliberately retain upstream US English so their files diff mechanically against upstream: `character-builder` (full retention) and `cinema-director` (partial — a targeted correction with named upstream-verbatim exceptions). Both carry their own in-file retention notes, which stand as written; this SOP defers to them and does not restate their detail. Nothing in the two-tier rule reopens either carve-out, and studio-authored prose added to those files is still Australian English.

---

## Cross-references

- Operative rule: `CLAUDE.md` § Output Locale
- Fast-Path inline pass: [Fast-Path Lane SOP](Fast-Path%20Lane%20SOP.md)
- Gate mechanics and verdicts: [QA Gate SOP](QA%20Gate%20SOP.md)
- Where the declaration lives: [Memory Protocol SOP](Memory%20Protocol%20SOP.md) § Project-scoped memory, [Project Folder SOP](Project%20Folder%20SOP.md)
