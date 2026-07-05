# herdr-launch.ps1 - check-and-install layer for herdr (https://herdr.dev), the
# agent multiplexer. Installer (install.bat -InstallOnly) and the VS Code
# startup terminal (.vscode/restore-terminals.json) both call this script so
# the check+install logic exists exactly once.
#
# Never depends on $PWD - all paths are $HOME/env based; herdr launches
# wherever the terminal's cwd happens to be.
#
# -InstallOnly: run the guarded install steps only, never launch herdr.

param(
    [switch]$InstallOnly
)

# --- Step a: herdr binary ---------------------------------------------------
$herdrCmd = Get-Command herdr -ErrorAction SilentlyContinue
if (-not $herdrCmd) {
    Write-Host "herdr not found - installing (Windows preview beta)..."
    try {
        Invoke-RestMethod -Uri "https://herdr.dev/install.ps1" -TimeoutSec 30 | Invoke-Expression
    } catch {
        Write-Host "WARNING: herdr install failed - install manually with: powershell -ExecutionPolicy Bypass -c `"irm https://herdr.dev/install.ps1 | iex`"" -ForegroundColor Yellow
    }

    # Refresh PATH from Machine + User registry scopes so a fresh install resolves this
    # session - appended, not replacing $env:Path, so session-only entries (e.g. a
    # temporarily-added node/npx path) survive.
    $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$env:Path;$machinePath;$userPath"

    $herdrCmd = Get-Command herdr -ErrorAction SilentlyContinue
}

# --- Step b: Claude Code integration -----------------------------------------
$claudeConfigDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME ".claude" }

if ($herdrCmd -and (Test-Path $claudeConfigDir)) {
    $hookExists = Test-Path (Join-Path $claudeConfigDir "hooks\herdr-agent-state.*")
    $settingsFile = Join-Path $claudeConfigDir "settings.json"
    $settingsHasHerdr = (Test-Path $settingsFile) -and (Select-String -Path $settingsFile -Pattern "herdr" -Quiet)

    if (-not $hookExists -and -not $settingsHasHerdr) {
        try {
            if (Test-Path $settingsFile) {
                Copy-Item $settingsFile "$settingsFile.herdr-backup" -Force
            }
            herdr integration install claude
            if ($LASTEXITCODE -ne 0) {
                Write-Host "WARNING: herdr Claude Code integration install failed - run manually: herdr integration install claude" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "WARNING: herdr Claude Code integration install failed - run manually: herdr integration install claude" -ForegroundColor Yellow
        }
    }
}

# --- Step c: agent skill -----------------------------------------------------
$skillDir = Join-Path $claudeConfigDir "skills\herdr"
$npxCmd = Get-Command npx -ErrorAction SilentlyContinue
if (-not (Test-Path $skillDir) -and $npxCmd) {
    $npxWarning = "WARNING: herdr agent skill install failed - run manually: npx -y skills add ogulcancelik/herdr --skill herdr -g"
    try {
        $proc = Start-Process npx -ArgumentList '-y', 'skills', 'add', 'ogulcancelik/herdr', '--skill', 'herdr', '-g' -NoNewWindow -PassThru
        if (-not $proc.WaitForExit(120000)) {
            $proc.Kill()
            Write-Host $npxWarning -ForegroundColor Yellow
        } elseif ($proc.ExitCode -ne 0) {
            Write-Host $npxWarning -ForegroundColor Yellow
        }
    } catch {
        Write-Host $npxWarning -ForegroundColor Yellow
    }
}

# --- Launch --------------------------------------------------------------
if (-not $InstallOnly) {
    $herdrCmd = Get-Command herdr -ErrorAction SilentlyContinue
    if ($herdrCmd) {
        herdr
    } else {
        Write-Host "WARNING: herdr still not on PATH - install manually with: powershell -ExecutionPolicy Bypass -c `"irm https://herdr.dev/install.ps1 | iex`"" -ForegroundColor Yellow
    }
}
