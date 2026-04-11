# session-start.ps1 -- Windows PowerShell port of session-start.sh
#
# Runs on bare Windows (PowerShell 5.1+ ships with every Windows 10+ install),
# so users without Git Bash or WSL still get the SessionStart auto-guidance.
# On non-Windows systems `powershell` is typically absent, so this hook entry
# exits with ENOENT and Claude Code silently skips it -- the bash entry wins.

$ErrorActionPreference = 'Stop'

# Force UTF-8 on stdout so non-ASCII characters in additionalContext survive
# Windows PowerShell 5.1's default OEM/Windows-1252 output encoding. Strings
# in this file stay ASCII-only as a second defense, since PS 5.1 also reads
# BOM-less .ps1 source files with the system ANSI codepage.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$ProfilePath = ".claude/.plugin-cache/guardians-of-the-claude/local/project-profile.md"

# Case 1: No Claude Code configuration at all
if (-not (Test-Path "CLAUDE.md") -and -not (Test-Path ".claude/settings.json")) {
    Write-Output @'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "This project has no Claude Code configuration yet. The guardians-of-the-claude plugin is installed -- suggest the user run /guardians-of-the-claude:create to set up CLAUDE.md and .claude/ configuration through a guided interview."
  }
}
'@
    exit 0
}

# Case 2: Configuration exists but no profile yet
if (-not (Test-Path $ProfilePath)) {
    Write-Output @'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Claude Code configuration exists but no project profile has been generated yet. Running /guardians-of-the-claude:audit will generate a project profile for more accurate recommendations across all skills."
  }
}
'@
    exit 0
}

# Case 3: Profile exists -- check for staleness.
# Keep this list in sync with session-start.sh.
$Manifests = @(
    "package.json", "package-lock.json", "pnpm-lock.yaml", "yarn.lock",
    "pnpm-workspace.yaml", "lerna.json", "nx.json", "turbo.json", "rush.json",
    "tsconfig.json",
    "pyproject.toml", "poetry.lock", "uv.lock", "requirements.txt",
    "go.mod", "go.sum",
    "Cargo.toml", "Cargo.lock",
    "pom.xml",
    "Gemfile", "Gemfile.lock",
    ".mcp.json", ".claude/settings.json"
)

$ProfileMtime = (Get-Item $ProfilePath).LastWriteTime
$StaleFile = $null
foreach ($f in $Manifests) {
    if (Test-Path $f) {
        if ((Get-Item $f).LastWriteTime -gt $ProfileMtime) {
            $StaleFile = $f
            break
        }
    }
}

if ($null -ne $StaleFile) {
    $Json = @"
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Project profile may be outdated -- $StaleFile was modified since the last profile update. Running /guardians-of-the-claude:audit will refresh the profile and check for new recommendations."
  }
}
"@
    Write-Output $Json
    exit 0
}

# Case 4: Everything is fresh -- no additional context needed
exit 0
