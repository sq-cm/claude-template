#!/usr/bin/env bash
# Run once after cloning to configure your local instance.
#
# Maintainer install: export CLAUDE_TEMPLATE_MAINTAINER=1 before running.
# Maintainer mode keeps push enabled and skips the read-only gate.

set -e

echo "=== Vault install ==="

if [ "${CLAUDE_TEMPLATE_MAINTAINER:-}" = "1" ]; then
  echo "  Maintainer mode detected (CLAUDE_TEMPLATE_MAINTAINER=1)"
  echo "  Push will remain enabled."
else
  # 1. Block push to upstream (this is someone else's template repo)
  if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url --push origin no_push
    echo "✓ Push to upstream blocked (fetch-only)"
  else
    echo "  (no 'origin' remote — skipping push-block)"
  fi
fi

# 2. Activate git hooks
git config core.hooksPath .githooks
RESOLVED_HOOKS=$(git config --get core.hooksPath)
if [ "$RESOLVED_HOOKS" = ".githooks" ]; then
  echo "✓ Git hooks activated (core.hooksPath=$RESOLVED_HOOKS)"
else
  echo "✗ Git hooks NOT activated — got: '$RESOLVED_HOOKS' (expected '.githooks')"
  exit 1
fi

# 2a. Ensure hook files are executable (no-op on Windows; harmless)
chmod +x .githooks/pre-commit .githooks/pre-push 2>/dev/null || true
chmod +x .claude/hooks/*.sh 2>/dev/null || true
chmod +x Vault/Scripts/*.sh 2>/dev/null || true
chmod +x .claude/statusline.sh 2>/dev/null || true

# 2b. Ignore working-tree exec-bit changes (stops phantom mode-diff noise).
#     Local-only config — git can't version it, so each clone sets it here.
#     Pairs with the 100755 index modes above; does not alter the index.
git config core.fileMode false
echo "✓ core.fileMode=false (exec-bit diff noise suppressed)"
find .claude/skills -name '*.sh' -exec chmod +x {} + 2>/dev/null || true

# 3. Copy env file if not present
if [ -f .env ]; then
  echo "  .env already exists, skipping"
elif [ -s .env.example ] && cp .env.example .env; then
  echo "✓ .env created — open it and add your credentials"
else
  echo "⚠ .env not created — .env.example is missing, empty or unreadable (partial pull?). Pull again, then re-run install.sh"
fi

# 3a. Seed per-clone local memory if not present (gitignored; MEMORY.md stays template-owned)
if [ -f Vault/Memory/context.md ]; then
  echo "  Vault/Memory/context.md already exists, skipping"
elif [ -s Vault/Memory/context.example.md ] && cp Vault/Memory/context.example.md Vault/Memory/context.md; then
  echo "✓ Vault/Memory/context.md created from template — your local team memory"
else
  echo "⚠ Vault/Memory/context.md not created — context.example.md is missing, empty or unreadable (partial pull?). Pull again, then re-run install.sh"
fi

# 3b. Seed the personal scratchpad if not present (gitignored; yours to edit freely)
mkdir -p Notes/Personal
if [ -f Notes/Personal/Notes.md ]; then
  echo "  Notes/Personal/Notes.md already exists, skipping"
elif [ -s Resources/Onboarding/Notes.example.md ] && cp Resources/Onboarding/Notes.example.md Notes/Personal/Notes.md; then
  echo "✓ Notes/Personal/Notes.md created from template — your personal scratchpad"
else
  echo "⚠ Notes/Personal/Notes.md not created — Notes.example.md is missing, empty or unreadable (partial pull?). Pull again, then re-run install.sh"
fi

echo ""
if [ "${CLAUDE_TEMPLATE_MAINTAINER:-}" = "1" ]; then
  echo "Maintainer install complete."
  echo "  - pre-commit + pre-push hooks honour CLAUDE_TEMPLATE_MAINTAINER=1 → your commits and pushes work normally."
  echo "  - Set CLAUDE_TEMPLATE_MAINTAINER=1 in your shell profile (e.g. ~/.bashrc, ~/.zshrc) so it persists."
else
  echo "Teammate install complete."
  echo "  - You can edit Chats/, Notes/, Projects/ freely — they're gitignored."
  echo "  - Commits touching other paths are blocked by .githooks/pre-commit."
  echo "  - Pushes are blocked (push URL set to 'no_push' + pre-push hook)."
  echo "  - Pull template updates anytime: git pull"
fi
echo ""
echo "Next steps:"
echo "  1. Open Claude Code in this folder. SessionStart hook runs /onboard automatically."
echo "  2. If onboarding flow didn't appear, run /onboard manually."
echo "  3. New users: read Resources/Onboarding/team-onboarding-guide.md"
echo "  4. Maintainers/ops: see Resources/Onboarding/SETUP.md"
