#!/usr/bin/env bash
# Run once after cloning to configure your local instance.

set -e

echo "=== Vault install ==="

# 1. Block push to upstream (this is someone else's template repo)
git remote set-url --push origin no_push
echo "✓ Push to upstream blocked (fetch-only)"

# 2. Activate git hooks
git config core.hooksPath .githooks
echo "✓ Git hooks activated"

# 3. Copy env file if not present
if [ ! -f .env ]; then
  cp .env.example .env
  echo "✓ .env created — open it and add your credentials"
else
  echo "  .env already exists, skipping"
fi

echo ""
echo "Done. See SETUP.md for remaining steps."
