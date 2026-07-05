param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"

$outputs = Join-Path $Root "outputs"
$previewDatePath = Join-Path $Root "preview-date.txt"
$entries = @()

if (Test-Path $outputs) {
    Get-ChildItem -LiteralPath $outputs -Directory |
        Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}$' } |
        Sort-Object Name -Descending |
        ForEach-Object {
            $date = $_.Name
            $linePath = Join-Path $_.FullName "line.txt"
            $imagePath = Join-Path $_.FullName "image.png"
            $metadataPath = Join-Path $_.FullName "metadata.json"

            if ((Test-Path $linePath) -and (Test-Path $imagePath)) {
                $line = ([System.IO.File]::ReadAllText($linePath, [System.Text.Encoding]::UTF8)).Trim()
                $createdAt = $null

                if (Test-Path $metadataPath) {
                    $metadataText = [System.IO.File]::ReadAllText($metadataPath, [System.Text.Encoding]::UTF8)
                    $metadata = $metadataText | ConvertFrom-Json
                    $createdAt = $metadata.created_at
                }

                $entries += [ordered]@{
                    date = $date
                    line = $line
                    image = "./outputs/$date/image.png"
                    text = "./outputs/$date/line.txt"
                    metadata = "./outputs/$date/metadata.json"
                    created_at = $createdAt
                }
            }
        }
}

$manifest = [ordered]@{
    updated_at = (Get-Date).ToString("o")
    entries = $entries
}

if (Test-Path $previewDatePath) {
    $previewDate = ([System.IO.File]::ReadAllText($previewDatePath, [System.Text.Encoding]::UTF8)).Trim()
    if ($previewDate -match '^\d{4}-\d{2}-\d{2}$') {
        $manifest.preview_date = $previewDate
    }
}

$json = $manifest | ConvertTo-Json -Depth 8
$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path $Root "manifest.json"), $json, $utf8)
Write-Host "Updated manifest.json with $($entries.Count) entries."
