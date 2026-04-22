@echo off
:: Run once after cloning to configure your local instance.

echo === Vault install ===

:: 1. Block push to upstream (this is someone else's template repo)
git remote set-url --push origin no_push
echo [OK] Push to upstream blocked (fetch-only)

:: 2. Activate git hooks
git config core.hooksPath .githooks
echo [OK] Git hooks activated

:: 3. Copy env file if not present
if not exist .env (
  copy .env.example .env >nul
  echo [OK] .env created -- open it and add your credentials
) else (
  echo      .env already exists, skipping
)

echo.
echo Done. See SETUP.md for remaining steps.
