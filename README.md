# Claude Team Workspace Template

**An AI agency in a folder.** Drop this into Claude Code and you have a 20-person team ready to take work — researchers, copywriters, SEO specialists, developers, designers, and more — all coordinated by a single orchestrator named Sam.

---

## What this is

Most AI setups give you one assistant. This gives you a team.

The **Orchestrator** is the single point of contact for every request. They never do the work themselves. Instead, they route each task to the right specialist: SEO audits go to the SEO Specialist, brand copy goes to Finn, UX reviews go to Jordan. Each team member has a detailed persona file defining their expertise, voice, constraints, and relationships.

The team grows with you. When you hit a capability gap, a built-in **hiring pipeline** kicks in: the Senior Researcher researches the role, the HR Lead builds the persona, the Orchestrator announces the new hire and updates the roster. No new infrastructure needed — just new files.

Quality gates are built in too. An Opus-powered advisor — the **Senior Adviser** — is consulted at checkpoints before and after substantive work, catching problems before they reach you.

---

## Quick start

1. Clone this repo
2. Open the folder as your working directory in [Claude Code](https://claude.ai/code)
3. Run `/onboard` — this locks the repo to pull-only (your local changes stay local) and completes first-time setup
4. Say hello:

```
Hi, what can the team help me with today?
```

That's it. Sam responds immediately. No API keys to wire up, no bootstrapping.

For full setup instructions (including secrets hygiene, path verification, and automated setup via a single Claude prompt): see [setup-guide.md](Resources/setup-guide.md).

---

## How it works

```
Your message
     ↓
  CLAUDE.md               ← orchestrator rules + active roster
     ↓
  Orchestrator            ← routes all requests; never does task work themselves
     ↓
  Team member             ← persona file defines who they are, what they do, what they won't
     ↓
  Senior Adviser (checkpoint) ← Opus advisor consulted before/after durable work
     ↓
  Deliverable             ← lands in Projects/[project]/Deliverables/
```

**Key files:**
- `CLAUDE.md` — the orchestrator's brain; defines the Orchestrator's rules, the hiring pipeline, checkpoint protocol, and the active team roster
- `Team/[Role]/[role].md` — each team member's persona: identity, expertise, constraints, relationships
- `Resources/SOPs/` — standard operating procedures for checkpoints, repo consultation, project folder structure, theming
- `.claude/skills/` — reusable skill modules (brainstorming, planning, debugging, code review, etc.)

---

## The team

| Role | Description |
|------|------|
| [Orchestrator](Team/Orchestrator/orchestrator.md) | Routes all requests, manages the roster, never does task work |
| [HR Lead](Team/HR%20Lead/hr-lead.md) | Builds new team member personas from the Senior Researcher's briefs |
| [Senior Researcher](Team/Senior%20Researcher/senior-researcher.md) | Researches roles before any new hire; writes role briefs |
| [SEO Specialist](Team/SEO%20Specialist/seo-specialist.md) | Audits, keyword strategy, technical SEO, Search Console analysis |
| [Webflow Developer](Team/Webflow%20Developer/webflow-developer.md) | Custom code embeds, JS interactions, CSS beyond Webflow's style panel |
| [Visual AI Producer](Team/Visual%20AI%20Producer/visual-ai-producer.md) | AI image generation, prompt engineering, visual asset delivery |
| [Copywriter](Team/Copywriter/copywriter.md) | Ad copy, landing pages, emails, social captions, website copy |
| [Brand Strategist](Team/Brand%20Strategist/brand-strategist.md) | Positioning, voice architecture, messaging frameworks, brand governance |
| [Content Strategist](Team/Content%20Strategist/content-strategist.md) | Content architecture, audits, editorial planning, briefs, measurement |
| [UX/UI Designer](Team/UX-UI%20Designer/ux-ui-designer.md) | IA, wireframing, interaction design, UX writing, Figma handoff |
| [Social Media Manager](Team/Social%20Media%20Manager/social-media-manager.md) | Publishing, scheduling, community management, platform analytics |
| [Video & Motion Producer](Team/Video%20&%20Motion%20Producer/video-&-motion-producer.md) | AI video generation, motion graphics, reels, animated assets |
| [Analytics & Reporting Specialist](Team/Analytics%20&%20Reporting%20Specialist/analytics-&-reporting-specialist.md) | Dashboards, performance reporting, attribution, data quality |
| [Creative Technologist](Team/Creative%20Technologist/creative-technologist.md) | Multi-step AI pipelines, prompt systems, structured output schemas |
| [Automation Architect](Team/Automation%20Architect/automation-architect.md) | Workflow automation, n8n/Make/Zapier, API and webhook integrations |
| [QA Compliance Reviewer](Team/QA%20Compliance%20Reviewer/qa-compliance-reviewer.md) | Quality gates — reviews deliverables before they reach the client |
| [Project Manager](Team/Project%20Manager/project-manager.md) | Delivery tracking, pipeline status, handoff coordination, timelines |
| [Creative Director](Team/Creative%20Director/creative-director.md) | Campaign concepts, creative territories, cross-channel coherence |
| [Amazon Stores Specialist](Team/Amazon%20Stores%20Specialist/amazon-stores-specialist.md) | Listings, A+ content, Stores, variation architecture, compliance |
| [Senior Adviser](Team/Senior%20Adviser/senior-adviser.md) | Checkpoint reviewer — consulted before and after durable work |

---

## The hiring pipeline

The team is not fixed. When a capability gap appears:

1. The **Orchestrator** identifies the gap and asks your permission to hire
2. The **Senior Researcher** researches the role — skills, knowledge domains, collaboration patterns, failure modes
3. The **HR Lead** reads the Senior Researcher's brief and writes a full persona file
4. The **Orchestrator** announces the hire and updates the Active Team Roster in `CLAUDE.md`

The new team member is immediately available. No code changes, no config — just a new markdown file.

---

## Sample projects

`Projects/` contains 5 half-finished sample projects. Each teaches a different workflow layer. Work through them after setup to learn the system by doing.

| # | Project | Teaches |
|---|---------|---------|
| 1 | Bloom Bakery — SEO Audit | Standard audit pipeline (Alex → Quinn → Deliverables) |
| 2 | Meridian Law — Homepage UX Review | Cross-functional handoff + WCAG compliance |
| 3 | NovaStar Gym — Social Media Calendar | Multi-specialist creative (Sage → {SocialMediaManager} → Cleo) |
| 4 | Thornwood Coffee — Brand Copywriting | {SeniorAdviser} Checkpoint A+B + repo consultation |
| 5 | Velora Studio — Hire Paid Media Specialist | Full hiring pipeline end-to-end |

Each project has a `README.md` with learning objectives and completion steps.

---

## Customising

**Rename the workspace:**
Duplicate this folder, rename it `Claude - [YourCompany]`, and open that copy in Claude Code. Update the memory path in `CLAUDE.md` to the absolute path of your new folder.

**Add a team member:**
Tell the Orchestrator you have a capability gap. The hiring pipeline handles the rest.

**Remove a team member:**
Tell the Orchestrator to archive them. The Orchestrator moves the persona file to `Vault/Archive/` and removes them from the roster.

**Apply a theme:**
Rename the team to match a theme of your choice (Greek myths, Studio Ghibli, etc.):
> "Set theme to [your theme]"

The Orchestrator will preview changes and ask for confirmation before touching anything. Full rollback map saved to `Vault/Memory/`.

---

## Requirements

- [Claude Code](https://claude.ai/code) — the CLI or desktop app
- Access to Claude models. @{SeniorAdviser} checkpoints use **Opus** — confirm your plan includes Opus access.
- No external API keys required for basic use

**OS note:** Example paths in `CLAUDE.md` and persona files use Windows-style absolute paths (`J:\My Drive\...`). Update the memory path in `CLAUDE.md` to match your OS and file system before first use.

---

## Repo layout

```
Claude - TEMPLATE/
├── .claude/
│   └── commands/
│       ├── onboard.md                 ← /onboard command (run first)
│       └── import-repos.md            ← /import-repos command
├── Inbox/                             ← staging area for unrouted material
├── Notes/                             ← daily notes, canvas files, clippings
├── Projects/
│   └── [5 sample onboarding projects]/
├── Resources/
│   ├── Git/                           ← cloned reference repos (git-ignored)
│   ├── Learn/                         ← onboarding guide (index.html)
│   ├── SOPs/                          ← Advisor Checkpoints, Repo Consultation, etc.
│   └── setup-guide.md                 ← full setup instructions
├── Team/
│   ├── Orchestrator/
│   ├── HR Lead/
│   ├── Senior Researcher/
│   │   └── Research/                  ← Senior Researcher's role research briefs
│   └── [17 more specialist roles]/
├── Vault/
│   ├── Archive/                       ← retired projects and personas
│   ├── Logs/                          ← clone failure logs, import logs
│   ├── Memory/                        ← persistent session memory
│   └── Templates/                     ← daily and weekly note templates
├── CLAUDE.md                          ← orchestrator rules + team roster
├── README.md                          ← this file
└── .env.example                       ← API key template
```

---

## Demo

![Orchestrator routing a request](Resources/sam-routing.gif)

---

## Licence

MIT. Fork it, adapt it, theme it, extend it.

---

## Contributing

Issues and PRs welcome. If you build a new persona, SOP, or skill worth sharing — open a PR with a brief description of what it covers and why.
