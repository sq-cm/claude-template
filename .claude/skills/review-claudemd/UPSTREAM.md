# review-claudemd — Upstream provenance

Maintainer-only. Moved here verbatim from `SKILL.md` on 19/11/2026 (plan 180) so it stops loading on every invocation; only comment delimiters were removed. In the moved text, "this header" means the comment block that sat at the top of `SKILL.md`; "below" and "this file" refer to `SKILL.md`. Read it before any resync.

## Moved 19/11/2026 (plan 180)

Source: https://github.com/ykdojo/claude-code-tips skills/review-claudemd (idea-level
adaptation — this build is a rewrite, not a port; pinned upstream commit `0307d5c`,
2026-06-22). Vault divergences from upstream: report-only hard rule (upstream offers to
draft edits); five lenses (upstream has four — Friction is vault-local); zero-dep Node
extractor replacing bash+jq (cross-platform, tool-call digests, mechanical hook-noise
stripping, secret redaction — upstream extracts text turns only); all CLAUDE.md tiers
including folder-tier; output to git-ignored Vault/Plans/ per vault convention.
