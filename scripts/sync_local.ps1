param(
    [switch]$RestoreState
)

$ErrorActionPreference = "Stop"

$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $root

if ((git branch --show-current) -ne "main") {
    throw "Local sync must run on the main branch."
}

$trackedChanges = git status --porcelain --untracked-files=no
if ($trackedChanges) {
    throw "Tracked files have local changes. Commit or stash them before syncing."
}

git fetch origin main
git merge --ff-only origin/main
if ($RestoreState) {
    python scripts/short_flow_state.py restore --force
}
python scripts/validate_dashboards.py

Write-Host "Local project is synchronized with origin/main."
