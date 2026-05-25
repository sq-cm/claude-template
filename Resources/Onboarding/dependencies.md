# Onboarding — External Tool Dependencies

Lists the external tools each persona needs to produce work. Read it before invoking a persona on a fresh clone. A missing Required tool blocks delivery. Living doc — update it when a persona's toolchain changes.

**Version drift.** MCP servers and CLI extensions change upstream without notice. Treat this as a pointer, not a pinned spec. If a tool behaves oddly, re-check the vendor docs linked below before debugging Claude Code.

## Inventory

| Persona | Tool | Type | Required/Optional | Where to get | If missing |
|---|---|---|---|---|---|
| Casey | Webflow MCP server (`https://mcp.webflow.com/mcp`) | MCP server | Required | Vendor docs: https://developers.webflow.com/data/docs/ai-tools — MCP URL is fixed by Webflow; configure as a remote MCP in Claude Code | Casey escalates to @{Orchestrator}; no manual UI fallback |
| Cleo | Gemini CLI + nanobanana extension (`/nano-banana` skill) | CLI extension | Required (any 1 of this or Higgsfield MCP) | Gemini CLI: https://github.com/google-gemini/gemini-cli · nanobanana extension install per its README | Cleo cannot use nanobanana path; falls back to Higgsfield MCP if installed |
| Cleo | Higgsfield MCP (`mcp__claude_ai_Higgsfield__*`) | MCP server | Required (any 1 of this or nanobanana) | Configure Higgsfield MCP server in Claude Code per Higgsfield docs | Cleo uses nanobanana path; Higgsfield alternative unavailable |
| Nova | Runway / Kling / Sora / Pika (named AI video tools) | SaaS subscription | Required (any 1 from set) | Vendor sites; paid subscriptions (runwayml.com, kling.ai, openai.com/sora, pika.art) | Nova cannot generate AI video; flag at intake |
| Nova | After Effects OR Premiere OR DaVinci Resolve | Desktop app | Required (any 1) | Adobe Creative Cloud (adobe.com) or Blackmagic Design (blackmagicdesign.com) | Nova cannot finish raw AI output; flag at intake |
| Jordan | Figma | SaaS subscription | Required | figma.com — paid plan (Starter or higher) | Jordan cannot produce primary deliverable; flag at intake |
| Jordan | FigJam | SaaS subscription | Optional (plan-tier dependent — included in Figma Professional and above; not Starter) | figma.com plan upgrade | Journey mapping and affinity mapping degrade to text-only |
| Jordan | Maze / Lyssna / UserTesting | SaaS subscription | Optional (any 1) | Vendor sites; paid subscriptions (maze.co, lyssna.com, usertesting.com) | Usability testing degrades to heuristic evaluation only |
| Jordan | Hotjar | SaaS subscription | Optional | hotjar.com | Behavioural analytics unavailable; rely on GA4 |

## Type definitions

| Type | Definition |
|---|---|
| MCP server | A Model Context Protocol server that Claude Code connects to at runtime to call external APIs or tools via structured tool calls. |
| CLI extension | A command-line tool or plugin installed locally that a persona invokes during generation tasks (e.g., Gemini CLI with a named skill extension). |
| API model | A specific AI model accessed via an authenticated API; availability depends on account tier or billing status with the model provider. |
| SaaS subscription | A cloud-hosted platform requiring a paid or free-tier account; accessed via browser or native app; not installed into Claude Code directly. |
| Desktop app | A locally installed application required to process or finish deliverables; cannot be substituted with a cloud alternative without changing the workflow. |

## How to populate or extend

Adding a tool:

1. Add a row to the Inventory table above.
2. Open `.claude/agents/[role-slug].md` and update the Runtime requirements callout to match — inventory and persona file must agree on tool, type, and Required/Optional status.
3. If Required, make sure the If missing behaviour is reflected in the persona's escalation logic.

Same two-file rule applies when removing a tool or flipping Required ↔ Optional. Update inventory and persona in the same commit.
