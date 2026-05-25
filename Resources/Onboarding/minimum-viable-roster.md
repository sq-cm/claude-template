# Minimum Viable Roster (MVR)

This document is for **clone operators** — if you're running a small creative/marketing studio (2–5 people), this guide helps you decide which AI team members to keep and which to remove from your vault clone. The template upstream keeps all 24 personas; cuts happen in your clone only, via [Roster Drift SOP](../../Resources/SOPs/Roster%20Drift%20SOP.md).

---

## How to use this guide

Read the tier descriptions below. **Tier 1 (Spine)** is non-negotiable — keep these five. Each higher tier unlocks capabilities as your team grows:

- **Tier 1**: Essential coordination and quality gates. Keep for any studio size.
- **Tier 2**: Solo/duo creatives (1–2 people). Add if you're writing copy or strategy.
- **Tier 3**: Growing to 3–5 people. Add when you need in-depth research or SEO expertise.
- **Tier 4**: Full studio (5+). Add specialists as your capacity and client scope grow.

For each persona, the entry shows the agent file name, why it's essential (or when to skip), and conditions under which removal makes sense.

---

## Tier 1 — Spine (always keep, 5)

**Orchestrator** — no agent file. Single point of contact; routes all requests. Core to every studio configuration.

**{HRLead} Harper** — `hr-lead.md`. Builds new team member personas from research briefs. Keep if you plan to hire custom specialists; skip if your team never grows beyond template personas.

**{SeniorAdviser} Odin** — `senior-adviser.md`. Quality checkpoint reviewer. Non-negotiable — invoked at every durable deliverable gate.

**{QAComplianceReviewer} Quinn** — `qa-compliance-reviewer.md`. Final gate before client delivery. Runs PASS/FLAGGED/BLOCKED verdicts. Keep even if you're small — quality gates scale.

**{ProjectManager} Tate** — `project-manager.md`. Tracks delivery, blocks, and timelines. Skip only if you never run more than one task in parallel (rarely true in production).

---

## Tier 2 — Solo/duo add (5)

Add these if you're a 1–2 person studio doing content strategy, copywriting, or brand work.

**{ContentStrategist} Sage** — `content-strategist.md`. Content architecture and audit. Essential if you produce blog posts, landing pages, or editorial content. Skip if you only build websites or do ads.

**{BrandStrategist} Remi** — `brand-strategist.md`. Brand positioning and messaging frameworks. Keep if clients need positioning work; skip if you're purely execution-focused.

**{Copywriter} Finn** — `copywriter.md`. Long-form and short-form copy. Non-negotiable if copy is part of your output — homepage, email, ads, social. Skip only if another studio handles all copy.

**{CreativeDirector} Vera** — `creative-director.md`. Campaign-level creative oversight and direction. Skip if you're too small for a separate design-strategy layer; Sage + Finn may be enough.

**{WebflowDeveloper} Casey** — `webflow-developer.md`. Webflow CMS and custom code. Keep if Webflow is your build platform; skip entirely if you use a different system.

---

## Tier 3 — Team 3–5 add (2)

Add these as you grow to 3–5 people and need deeper expertise.

**{SEOSpecialist} Alex** — `seo-specialist.md`. Technical SEO, content strategy, link authority. Add when organic search becomes a major client output. Skip if you only do paid or brand work.

**{SeniorResearcher} Ryan** — `senior-researcher.md`. Structured research briefs and role mapping. Add when you need documented research for positioning, competitive analysis, or audience work. Skip if research is light or delegated to clients.

---

## Tier 4 — Full studio 5+ (13)

Add as your team grows and client scope broadens.

**{VisualAIProducer} Cleo** — `visual-ai-producer.md`. AI image generation and visual direction. Add when visual assets become part of your deliverables (brand campaigns, social, e-commerce).

**{CreativeTechnologist} Ellis** — `creative-technologist.md`. Prompt systems, AI pipelines, workflow design. Add when you need to automate creative production or build reliable AI-assisted systems. Can be deferred if all work is bespoke.

**{VideoMotionProducer} Nova** — `video-motion-producer.md`. AI video and motion design. Add only if video is a primary studio output; skip for copy/design/web-only studios.

**{AutomationArchitect} Axel** — `automation-architect.md`. Workflow automation (n8n, Make, Zapier). Add when you're building client systems or connecting tools. Skip if automation is out-of-scope.

**{SocialMediaManager} Juno** — `social-media-manager.md`. Social calendars and community management. Add when social is a core client deliverable. Skip if social is bundled under another role.

**{AnalyticsReportingSpecialist} Dex** — `analytics-reporting-specialist.md`. Performance reporting and data analysis. Add when measurement/reporting is billable. Skip if analytics is light or owned by clients.

**{UXUIDesigner} Jordan** — `ux-ui-designer.md`. UX research, wireframing, design systems. Add when interface design is a separate discipline from development (especially with Casey as developer). Skip if design and build are one role.

**{EmailDeveloper} Rory** — `email-developer.md`. HTML email and multi-client rendering. Add only if email is a primary deliverable (nurture, campaigns). Skip if email copy/design is in-house or rare.

**{CompetitiveIntelligenceSpecialist} Kai** — `competitive-intelligence-specialist.md`. Competitive analysis and battlecard development. Add when competitive positioning is a billable output. Skip if research stays under Ryan (Tier 3).

**{MarketResearchSpecialist} Reid** — `market-research-specialist.md`. Primary research, surveys, audience segmentation. Add when structured fieldwork and audience research are core to your offering. Skip if secondary research (Kai/Ryan) covers your needs.

**{BusinessAnalyst} Drew** — `business-analyst.md`. RFQ analysis, scope definition, brief qualification. Add when intake quality control becomes a bottleneck. Skip if the Orchestrator or a client-side PM already handles intake and scoping.

**{MetaAdsSpecialist} Luca** — `meta-ads-specialist.md`. Meta platform strategy and compliance. Add only if paid social is a primary studio service. Skip if ads are handled externally or via a larger team.

**{MobileDeveloper} Milo** — `mobile-developer.md`. React Native and app store delivery. Add only if mobile app development is in scope. Skip entirely for web-only studios.

---

## Removal procedure

To remove personas from your clone, follow [Roster Drift SOP](../../Resources/SOPs/Roster%20Drift%20SOP.md) — it covers agent file deletion, theme map updates, CLAUDE.md cleanup, and git tracking. Do not delete manually.

---

## Verification

After removing personas, verify:

1. Agent files deleted from `.claude/agents/`.
2. Theme name map (`Vault/Memory/theme-name-map.md`) updated.
3. CLAUDE.md updated if constraints mention deleted roles.
4. `git status` shows only intended deletions.

If unsure, consult the SOP or ask the Orchestrator.
