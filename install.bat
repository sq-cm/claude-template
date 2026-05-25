@echo off
:: Run once after cloning to configure your local instance.
::
:: Maintainer install: set CLAUDE_TEMPLATE_MAINTAINER=1 before running.
:: Maintainer mode keeps push enabled and skips the read-only gate.

setlocal

echo === Vault install ===

if "%CLAUDE_TEMPLATE_MAINTAINER%"=="1" (
  echo   Maintainer mode detected ^(CLAUDE_TEMPLATE_MAINTAINER=1^)
  echo   Push will remain enabled.
) else (
  :: 1. Block push to upstream (this is someone else's template repo)
  git remote set-url --push origin no_push
  echo [OK] Push to upstream blocked (fetch-only)
)

:: 2. Activate git hooks
git config core.hooksPath .githooks
for /f "delims=" %%i in ('git config --get core.hooksPath') do set RESOLVED_HOOKS=%%i
if "%RESOLVED_HOOKS%"==".githooks" (
  echo [OK] Git hooks activated (core.hooksPath=%RESOLVED_HOOKS%)
) else (
  echo [FAIL] Git hooks NOT activated -- got: '%RESOLVED_HOOKS%' (expected '.githooks')
  exit /b 1
)

:: 3. Copy env file if not present
if not exist .env (
  copy .env.example .env >nul
  echo [OK] .env created -- open it and add your credentials
) else (
  echo      .env already exists, skipping
)

echo.
if "%CLAUDE_TEMPLATE_MAINTAINER%"=="1" (
  echo Maintainer install complete.
  echo   - pre-commit + pre-push hooks honour CLAUDE_TEMPLATE_MAINTAINER=1 -- your commits and pushes work normally.
  echo   - Set CLAUDE_TEMPLATE_MAINTAINER=1 as a persistent user env var so it survives new shells.
) else (
  echo Teammate install complete.
  echo   - You can edit Inbox\, Notes\, Projects\ freely -- they're gitignored.
  echo   - Commits touching other paths are blocked by .githooks\pre-commit.
  echo   - Pushes are blocked (push URL set to 'no_push' + pre-push hook).
  echo   - Pull template updates anytime: git pull
)
echo.
echo Next steps:
echo   1. Open Claude Code in this folder. SessionStart hook runs /onboard automatically.
echo   2. If onboarding flow didn't appear, run /onboard manually.
echo   3. New users: read Resources\Onboarding\team-onboarding-guide.md
echo   4. Maintainers/ops: see Resources\Onboarding\SETUP.md

endlocal
