# Resources/Build Standards

Authoritative technical standards for specialized roles. These files define how work is executed at the code level and are extracted from persona files for maintainability and clarity.

## Current Standards

| File                                                              | Role    | Purpose                                                                                    |
| ----------------------------------------------------------------- | ------- | ------------------------------------------------------------------------------------------ |
| [`email-build-standards.md`](email-build-standards.md)            | Rory    | HTML email code patterns, deliverables structure, and QA requirements for all email builds |
| [`html-deliverable-standards.md`](html-deliverable-standards.md)  | Ellis   | HTML-companion build rules — vanilla-only, accessibility, print, footer spec, file constraints |
| [`code-minimalism-standard.md`](code-minimalism-standard.md)      | Casey, Rory, Milo, Axel, Ellis | Decision ladder + guards for minimal code; enforced via the code-minimalism-review skill |

## Ownership

Build standards are maintained by the assigned role and referenced from their persona file. Changes should be routed through @{Orchestrator} and may require an Advisor Checkpoint if they affect team-wide practices.

## Adding a new standard

1. Extract the relevant section from the persona file (with Odin's approval via Checkpoint A)
2. Create a new `.md` file in this folder with a clear title and purpose statement
3. Update the persona to link to the new standard file
4. Add an entry to this README
