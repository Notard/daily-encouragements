param(
    [string]$RemoteUrl = "",
    [string]$Branch = "main",
    [string]$Message = "Update daily encouragement site"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

& (Join-Path $PSScriptRoot "Update-Manifest.ps1") -Root $Root

if (-not (Test-Path (Join-Path $Root ".git"))) {
    git -C $Root init
    git -C $Root checkout -B $Branch
}

if ($RemoteUrl) {
    $remoteNames = git -C $Root remote
    if ($remoteNames -contains "origin") {
        git -C $Root remote set-url origin $RemoteUrl
    } else {
        git -C $Root remote add origin $RemoteUrl
    }
}

$origin = git -C $Root remote get-url origin 2>$null
if (-not $origin) {
    throw "GitHub 저장소 URL이 필요합니다. -RemoteUrl 'https://github.com/USER/REPO.git' 형식으로 다시 실행해 주세요."
}

git -C $Root add .

$changes = git -C $Root status --porcelain
if ($changes) {
    git -C $Root commit -m $Message
} else {
    Write-Host "No changes to commit."
}

git -C $Root push -u origin $Branch
Write-Host "Published to $origin"
