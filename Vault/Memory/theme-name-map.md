# Theme Name Map

Maps role tokens to current team member names. Update this file to swap team members.

```yaml
Studio: Studio Quarantine  # Replace with your studio name; loaded at session start as {{Studio}}
Orchestrator: Sam
HRLead: Harper
SeniorResearcher: Ryan
SEOSpecialist: Alex
WebflowDeveloper: Casey
VisualAIProducer: Cleo
SeniorAdviser: Odin
ContentStrategist: Sage
QAComplianceReviewer: Quinn
Copywriter: Finn
BrandStrategist: Remi
CreativeTechnologist: Ellis
VideoMotionProducer: Nova
AutomationArchitect: Axel
SocialMediaManager: Juno
AnalyticsReportingSpecialist: Dex
UXUIDesigner: Jordan
ProjectManager: Tate
CreativeDirector: Vera
EmailDeveloper: Rory
CompetitiveIntelligenceSpecialist: Kai
MarketResearchSpecialist: Reid
BusinessAnalyst: Drew
MetaAdsSpecialist: Luca
MobileDeveloper: Milo
CinemaShowrunner: Marlowe
StillsDirector: Iris
SeedanceDirector: Dash
```

## Studio Variable

Studio name is used in HTML deliverable footers and other branded outputs via the `{{Studio}}` token. Change it to your studio's name before producing client deliverables.

## File Path Convention

Persona files live at `.claude/agents/[role-slug].md`. Use the explicit map below — naive camelCase→kebab conversion breaks on acronym-heavy tokens (e.g. `UXUIDesigner`, `SEOSpecialist`).

| Token | Agent file |
|-------|-----------|
| HRLead | `hr-lead.md` |
| SeniorResearcher | `senior-researcher.md` |
| SEOSpecialist | `seo-specialist.md` |
| WebflowDeveloper | `webflow-developer.md` |
| VisualAIProducer | `visual-ai-producer.md` |
| SeniorAdviser | `senior-adviser.md` |
| ContentStrategist | `content-strategist.md` |
| QAComplianceReviewer | `qa-compliance-reviewer.md` |
| Copywriter | `copywriter.md` |
| BrandStrategist | `brand-strategist.md` |
| CreativeTechnologist | `creative-technologist.md` |
| VideoMotionProducer | `video-motion-producer.md` |
| AutomationArchitect | `automation-architect.md` |
| SocialMediaManager | `social-media-manager.md` |
| AnalyticsReportingSpecialist | `analytics-reporting-specialist.md` |
| UXUIDesigner | `ux-ui-designer.md` |
| ProjectManager | `project-manager.md` |
| CreativeDirector | `creative-director.md` |
| EmailDeveloper | `email-developer.md` |
| CompetitiveIntelligenceSpecialist | `competitive-intelligence-specialist.md` |
| MarketResearchSpecialist | `market-research-specialist.md` |
| BusinessAnalyst | `business-analyst.md` |
| MetaAdsSpecialist | `meta-ads-specialist.md` |
| MobileDeveloper | `mobile-developer.md` |
| CinemaShowrunner | `cinema-showrunner.md` |
| StillsDirector | `stills-director.md` |
| SeedanceDirector | `seedance-director.md` |

> **Note:** `Orchestrator` is the only token with no corresponding `.claude/agents/` file. Its behaviour is defined in `CLAUDE.md` directly. All other tokens must have a matching agent file.

## How to Use

When you want to swap a team member:

1. Update the YAML above with the new person's name
2. Example: `Orchestrator: NewOrchestratorName`
3. Sam automatically translates `@{Orchestrator}` → `@NewOrchestratorName` at session start

## Theme Swaps

To completely rebrand the team (e.g., use a different name theme):

- Update all name values above
- File paths stay role-based — no files or folders are renamed
- All @{RoleToken} routing automatically uses the new names
