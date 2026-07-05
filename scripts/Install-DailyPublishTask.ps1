param(
    [string]$TaskName = "Publish Daily Encouragement Site",
    [string]$At = "08:15"
)

$ErrorActionPreference = "Stop"

$publishScript = Join-Path $PSScriptRoot "Publish-GitHubPages.ps1"
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$publishScript`""
$trigger = New-ScheduledTaskTrigger -Daily -At $At
$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Force | Out-Null

Write-Host "Installed scheduled task '$TaskName' at $At."
