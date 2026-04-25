# Theme Name Map

Maps role tokens to current team member names. Update this file to swap team members.

```yaml
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
AmazonStoresSpecialist: Milo
```

## File Path Convention

Persona files live at `.claude/agents/[role].md`. Example: `.claude/agents/seo-specialist.md`. The Orchestrator can derive any persona path from the role slug without a lookup table.

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
