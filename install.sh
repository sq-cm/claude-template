#!/usr/bin/env bash
# Run once after cloning to configure your local instance.
#
# Maintainer install: export CLAUDE_TEMPLATE_MAINTAINER=1 before running.
# Maintainer mode keeps push enabled and skips the read-only gate.

set -e

echo "=== Vault install ==="

if [ "$CLAUDE_TEMPLATE_MAINTAINER" = "1" ]; then
  echo "  Maintainer mode detected (CLAUDE_TEMPLATE_MAINTAINER=1)"
  echo "  Push will remain enabled."
else
  # 1. Block push to upstream (this is someone else's template repo)
  git remote set-url --push origin no_push
  echo "✓ Push to upstream blocked (fetch-only)"
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

# 3. Copy env file if not present
if [ ! -f .env ]; then
  cp .env.example .env
  echo "✓ .env created — open it and add your credentials"
else
  echo "  .env already exists, skipping"
fi

echo ""
if [ "$CLAUDE_TEMPLATE_MAINTAINER" = "1" ]; then
  echo "Maintainer install complete."
  echo "  - pre-commit + pre-push hooks honour CLAUDE_TEMPLATE_MAINTAINER=1 → your commits and pushes work normally."
  echo "  - Set CLAUDE_TEMPLATE_MAINTAINER=1 in your shell profile (e.g. ~/.bashrc, ~/.zshrc) so it persists."
else
  echo "Teammate install complete."
  echo "  - You can edit Inbox/, Notes/, Projects/ freely — they're gitignored."
  echo "  - Commits touching other paths are blocked by .githooks/pre-commit."
  echo "  - Pushes are blocked (push URL set to 'no_push' + pre-push hook)."
  echo "  - Pull template updates anytime: git pull"
fi
echo ""
echo "Next: see Resources/Onboarding/SETUP.md for remaining steps."
