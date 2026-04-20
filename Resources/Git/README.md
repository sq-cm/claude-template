# Resources/Git

Local repository clones used by the team — tools, skill libraries, reference code.

## Convention

One subfolder per repo, named after the repo:

```
Resources/Git/
  repo-name/
  another-repo/
```

**Name collision rule:** If two repos share the same name, append the owner username as a suffix:
```
awesome-claude-plugins-quemsah/
awesome-claude-plugins-composio/
```

## Gitignore

Cloned repos are excluded from version control via the root `.gitignore` wildcard:

```
Resources/Git/*/
```

Only `INDEX.md`, `README.md`, and `IMPORT.md` are committed. No per-repo entries needed.

## Adding repos

Drop GitHub URLs into `IMPORT.md` (one per line) and run `/import-repos`. The Orchestrator will clone each repo, append it to this table, and update `INDEX.md`.

## Cloned Repos

| Folder | Source | Description |
|---|---|---|


## Notes

- Read-only reference use only — don't develop inside these clones
- Pull updates manually when needed; no auto-sync assumed
