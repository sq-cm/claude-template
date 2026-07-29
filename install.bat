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
  git remote get-url origin >nul 2>&1
)

:: The origin check, the set-url, and the %RESOLVED_PUSH% set-then-read below
:: are each their own top-level statement, never sharing a ( ) block with
:: another one -- without EnableDelayedExpansion (this script never turns it
:: on, see the setlocal line above), a variable inside a parenthesised block
:: is expanded once when the block is parsed, not when it runs, so a
:: same-block read would see the value from before this script started. A
:: second, unrelated trap: `exit /b` two ( ) levels deep (an inner if nested
:: inside the outer else above) does not propagate its exit code to the
:: process when this script is run directly rather than `call`ed -- confirmed
:: empirically -- so this check also had to move out to its own top-level
:: statement. Mirrors the git-hooks verification block below, which nests
:: only one level deep and does not hit either trap.
if not "%CLAUDE_TEMPLATE_MAINTAINER%"=="1" if errorlevel 1 (
  echo [FAIL] No 'origin' remote -- cannot block push. Clone this repo with git and re-run.
  exit /b 1
)
if not "%CLAUDE_TEMPLATE_MAINTAINER%"=="1" git remote set-url --push origin no_push
if not "%CLAUDE_TEMPLATE_MAINTAINER%"=="1" for /f "delims=" %%i in ('git remote get-url --push origin') do set RESOLVED_PUSH=%%i
if not "%CLAUDE_TEMPLATE_MAINTAINER%"=="1" if "%RESOLVED_PUSH%"=="no_push" (
  echo [OK] Push to upstream blocked ^(fetch-only^)
) else (
  echo [FAIL] Push NOT blocked -- push URL is '%RESOLVED_PUSH%' ^(expected 'no_push'^)
  exit /b 1
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

:: 2a. Executable bits -- Windows note.
::     install.sh runs chmod +x on .githooks/, .claude/hooks/*.sh, Vault/Scripts/*.sh,
::     and .claude/skills/**/*.sh after this block. Exec bits do not exist on Windows,
::     so that step is a deliberate no-op here. Executable permissions are managed via
::     the committed git index mode (100755) and .gitattributes; no working-tree chmod
::     is required on Windows and none is attempted.
::
:: 2b. Ignore working-tree exec-bit changes (stops phantom mode-diff noise on Windows).
::     Local-only config -- git can't version it, so each clone sets it here.
git config core.fileMode false
echo [OK] core.fileMode=false (exec-bit diff noise suppressed)

:: 3. Copy env file if not present
if not exist .env (
  copy .env.example .env >nul
  echo [OK] .env created -- open it and add your credentials
) else (
  echo      .env already exists, skipping
)

:: 3a. Seed per-clone local memory if not present (gitignored; MEMORY.md stays template-owned)
if not exist "Vault\Memory\context.md" (
  copy "Vault\Memory\context.example.md" "Vault\Memory\context.md" >nul
  echo [OK] Vault\Memory\context.md created from template -- your local team memory
) else (
  echo      Vault\Memory\context.md already exists, skipping
)

echo.
if "%CLAUDE_TEMPLATE_MAINTAINER%"=="1" (
  echo Maintainer install complete.
  echo   - pre-commit + pre-push hooks honour CLAUDE_TEMPLATE_MAINTAINER=1 -- your commits and pushes work normally.
  echo   - Set CLAUDE_TEMPLATE_MAINTAINER=1 as a persistent user env var so it survives new shells.
) else (
  echo Teammate install complete.
  echo   - You can edit Notes\, Projects\ freely -- they're gitignored.
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
